//
//  HomeViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import UIKit

class HomeViewController: BaseViewController{
    
    private var posts : [Post] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Осеки"
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
        
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        view.backgroundColor = .clear
        tableView.tableHeaderView = view
        

        return tableView
    }()
    
    
    private lazy var createPostButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Resources.Colors.activeColor
        button.tintColor = .white
        button.setImage(.init(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.addTarget(self, action: #selector(createPostPressed), for: .touchUpInside)
        return button
    }()

    
    private func fetchAllPosts(){
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            guard let self = self else { return }
            self.posts = posts
            DispatchQueue.main.async{
               
                self.tableView.reloadData()
            }
        }
    }
}



extension HomeViewController: UINavigationControllerDelegate{
    override func addViews(){
        super.addViews()
        view.addSubview(tableView)
        view.addSubview(titleLabel)

        view.addSubview(createPostButton)

    }
    override func setUpConstraints(){
        super.setUpConstraints()
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        createPostButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    override func configure(){
        super.configure()
        view.backgroundColor = .black
        fetchAllPosts()
        navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.backgroundColor =  .clear
        tableView.backgroundColor = .black
        
        navigationController?.delegate = self

        navigationController?.navigationBar.isHidden = true
        
        tabBarController?.tabBar.barTintColor = .clear
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            if viewController == self {
                self.navigationController?.navigationBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}


@objc extension HomeViewController{
    func createPostPressed(){
        let vc = CreatePostViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.onPostSuccess = { [weak self] in
                    self?.fetchAllPosts()
                    self?.navigationController?.navigationBar.isHidden = true
                }
        present(navVC, animated: true)
    }
  
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("pochemuto mnogo raz \(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
        else{ fatalError() }
        

        

        cell.onAuthorPressed = { [weak self] in
            guard let navigationController = self?.navigationController else { return }
            let vc = ProfileViewController(currentEmail: post.author?.email ?? "Error")
            navigationController.navigationBar.isHidden = false
            self?.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(vc, animated: true)
        }
        
        guard let author = post.author else{return UITableViewCell()}
        cell.configure(viewModel: PostViewModel(title: post.title, imageURL: post.headerImageUrl, description: post.text, user: author))
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 620
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("vibral \(indexPath.row) a v massive \(posts[indexPath.row].title)")
        let vc = PostViewController(post: posts[indexPath.row])
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
