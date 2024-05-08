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
    
    private var authorView: UIView = {
       let view = AuthorView()
        view.configure(authorNickName: "author", authorImage: nil)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: PostViewModel){
        let description: String = viewModel.description ?? ""
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = description
        
         if let data = viewModel.imageData{
             postImageView.image = UIImage(data: data)
         }else if let url = viewModel.imageURL{
             let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, _ in
                 guard let data = data else{return}
                 viewModel.imageData = data
                 
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
        contentView.addSubview(authorView)
        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
    }
    
    func setUpConstraints() {
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
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(postImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(60)

        }
    }
    
    func configure(){
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
  


}
