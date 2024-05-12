//
//  PostTableViewCell.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit

class PostTableViewCell: UITableViewCell{
    static let identifier = "PostTableViewCell"
    var isConfigured = false
    var currentEmail = ""
    var onAuthorPressed: (() -> Void)?
    private var authorView: AuthorView = {
       let view = AuthorView()
        view.isUserInteractionEnabled = true

        view.configure(authorNickName: "author", authorImage: nil)
        return view
        
    }()
    private lazy var spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
        
    }()
    private lazy var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.passiveBackgroundColor
        view.layer.cornerRadius = 10
        return view
        
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        return label
        
    }()
    
    private lazy var postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 3
        label.text = "fsdlfgknsfgnje ewkrjgnwke jbgwek jbrgklew bkgb ewkrjb gkwerbjgenrw nlwekjr "
        return label
    }()
    
    private lazy var interactionStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white

        button.backgroundColor = Resources.Colors.passiveColor
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        
        return button
        
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white

        button.backgroundColor = Resources.Colors.passiveColor
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "message"), for: .normal)
        
        return button
        
    }()
    
    private lazy var repostButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white

        button.backgroundColor = Resources.Colors.passiveColor
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        
        return button
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: PostViewModel){
        let description: String = viewModel.description ?? ""
        currentEmail = viewModel.author.email
        titleLabel.text = viewModel.title
        descriptionLabel.text = description
        authorView.setTitle(nickName: viewModel.author.nickName)
        guard !isConfigured else {return}
        isConfigured = true
         if let data = viewModel.postImageData{
             postImageView.image = UIImage(data: data)
         }else if let url = viewModel.postImageURL{
             let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, _ in
                 guard let data = data else{return}
                 viewModel.postImageData = data
                 
                 DispatchQueue.main.async {
                     self?.postImageView.image = UIImage(data: data)
                     
                 }
             }
             task.resume()
         }
     }
    
    
    
}

extension PostTableViewCell{
    func setupUI() {
        addViews()
        setUpConstraints()
        configure()
    }
    
    func addViews() {
        contentView.addSubview(customContentView)
        customContentView.addSubview(authorView)
        customContentView.addSubview(postImageView)
        customContentView.addSubview(titleLabel)
        customContentView.addSubview(descriptionLabel)
        customContentView.addSubview(interactionStackView)
        
        interactionStackView.addArrangedSubview(likeButton)
        interactionStackView.addArrangedSubview(commentButton)
        interactionStackView.addArrangedSubview(repostButton)
        

        contentView.addSubview(spaceView)
    }
    
    func setUpConstraints() {
        customContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        spaceView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(10)
            
        }
        authorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.lessThanOrEqualTo(60)

        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(postImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(45)
        }
        
        interactionStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalTo(descriptionLabel.snp.leading)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        commentButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        repostButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
    
    func configure(){
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorViewTapped))
        authorView.addGestureRecognizer(tapGesture)
    }
  


}


@objc extension PostTableViewCell{
    func authorViewTapped(){
        guard let authorPessed = onAuthorPressed else{return}
        authorPessed()
    }
}
