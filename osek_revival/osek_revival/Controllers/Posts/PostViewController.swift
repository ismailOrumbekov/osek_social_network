//
//  PostViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import UIKit

class PostViewController: BaseViewController {

    private let post: Post
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        return tableView
    }()
    
    
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: UI Set ups
extension PostViewController{
    override func addViews(){
        super.addViews()
        view.addSubview(tableView)
    }
    override func setUpConstraints(){
        super.setUpConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configure(){
        super.configure()
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false
        
        
    }

}


extension PostViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.title
            cell.textLabel?.textColor = .white
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .black
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                            PostHeaderTableViewCell.identifier,
                                                            for: indexPath) as? PostHeaderTableViewCell
            else{fatalError()}
            cell.selectionStyle = .none
            cell.configure(viewModel: PostHeaderTableViewCellViewModel(imageURL: post.headerImageUrl))
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.text
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black

            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell

        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index{
        case 0:
            return UITableView.automaticDimension
        case 1:
           return 350
        case 2:
            return UITableView.automaticDimension

        default:
            return UITableView.automaticDimension
        }
    }
}
