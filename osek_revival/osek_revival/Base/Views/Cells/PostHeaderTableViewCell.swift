//
//  PostHeaderTableViewCell.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit

class PostHeaderTableViewCell: UITableViewCell{
    static let identifier = "PostHeaderTableViewCell"
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func configure(viewModel: PostHeaderTableViewCellViewModel){
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



extension PostHeaderTableViewCell{
    
    func setupUI() {
        addViews()
        setUpConstraints()
        configure()
    }
    
    func addViews() {
        contentView.addSubview(postImageView)

        
    }
    
    func setUpConstraints() {
        postImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
     
     
      
    }
    
    func configure(){
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
  
}
