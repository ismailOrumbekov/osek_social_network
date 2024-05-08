//
//  AuthorView.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 08.05.2024.
//

import Foundation
import UIKit
import SnapKit

class AuthorView: BaseView{
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "comicIcon")
        return imageView
    }()
    
    private lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.passiveColor
        return view
    }()
    
    private lazy var authorNickLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        return label
    }()
    
    func setTitle(nickName: String){
        authorNickLabel.text = nickName
    }
    
    func configure(authorNickName: String, authorImage: UIImage?){
        authorNickLabel.text = authorNickName
        
        guard let image = authorImage else {return}
        imageView.image = authorImage
    }
    
}

extension AuthorView{
    override func addViews(){
        super.addViews()
        addSubview(imageView)
        addSubview(authorNickLabel)
        addSubview(seperator)
    }
    override func setUpConstraints(){
        super.setUpConstraints()
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        authorNickLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        seperator.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
    }
    override func configure(){
        super.configure()
    }

}
