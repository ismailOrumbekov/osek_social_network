//
//  PostPreviewTableViewCell.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit
import SnapKit

class PostPreviewTableViewCell: UITableViewCell{
    static let identifier = "PostPreviewTableViewCell"
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
        postTitleLabel.text = viewModel.title
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

extension PostPreviewTableViewCell{
    
    func setupUI() {
        addViews()
        setUpConstraints()
        configure()
    }
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(postImageView)
        cellView.addSubview(postTitleLabel)

        
    }
    
    func setUpConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        postTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(postImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        
      
    }
    
    func configure(){
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
  
}

