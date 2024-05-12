//
//  ProfileViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import UIKit

enum ProfileType{
    case currentUser
    case otherUser
}

class ProfileViewController: BaseViewController{
    private var posts: [Post] = []
    var currentEmail: String
    private var user: User?
    private lazy var header = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 700))
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
        
    }()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.tableHeaderView = header
        
        tableView.backgroundColor = .black
        return tableView
    }()
    
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpTableHeader(profilePhotoRef: String? = nil, nickname: String? = nil){
        if let name = nickname{
            header.setNickName(nickName: name)
        }
        if let ref = profilePhotoRef{
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {return}
                
                let task = URLSession.shared.dataTask(with: url) { [weak self]data, _, _ in
                    guard let data = data else{return}
                    
                    DispatchQueue.main.async {
                        guard let self = self else{return}
                        self.header.setProfileImage(profileImage: UIImage(data: data))
                    }
                }
                task.resume()
            }
            
        }
        
    }
    
    func  fetchProfileData(){
        
        DatabaseManager.shared.getUser(email: currentEmail) {[weak self] user in
            guard let user = user else {return}
            DispatchQueue.main.async {
                self?.setUpTableHeader(profilePhotoRef: user.profileRef, nickname: user.nickName)
            }
            self?.user = user
            print("user saved \(user)")
            
        }
        
    }
    
    func fetchPosts(){
        print("was in posts method")

        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("posts is workinkg \(posts)")
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
    }
}



//MARK: Set up UI
extension ProfileViewController{
    
    override func addViews(){
        super.addViews()
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    override func setUpConstraints(){
        super.setUpConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalTo(tableView.snp.top).offset(-10)
            
        }
    }
    
    override func configure(){
        super.configure()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(signOutPressed))
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhotoPressed))
        header.setGestureRecognizer(tap: tap)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        header.createPostButton.addTarget(self, action: #selector(createPostPressed), for: .touchUpInside)
        fetchProfileData()
        fetchPosts()
                
    }

}



//MARK: Table view set ups
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
                
        else{
            fatalError()
        }
        guard let author = post.author else{
            print("kotakbas")
            return UITableViewCell()}

        cell.configure(viewModel: PostViewModel(title: post.title, imageURL: post.headerImageUrl, description:post.text, user: author))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = PostViewController(post: posts[indexPath.row])
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
  
}


//MARK: Image picker

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else{return}
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) {[weak self] success in
            guard let strongSelf = self else {return}
            if success{
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { success in
                    guard success else {return}
                    DispatchQueue.main.async{
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}


//MARK: Selectors

@objc extension ProfileViewController{
    func profilePhotoPressed(){
        print("was here")
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
        myEmail == currentEmail else {return}
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func createPostPressed(){
        let vc = CreatePostViewController()
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }

    
    
    func signOutPressed(){
        let alert = UIAlertController(title: "Выход", message: "Вы уврены, что хотите выйти?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { action in
            AuthManager.shared.signOut { success in
                if success{
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "nickname")
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        let navVC = UINavigationController(rootViewController: SignInViewController())
                        navVC.modalPresentationStyle = .fullScreen
                        navVC.navigationBar.prefersLargeTitles = true
                        self.present(navVC, animated: true)
                    }
                }
            }

        })
        
        present(alert, animated: true)
        
            }
}
