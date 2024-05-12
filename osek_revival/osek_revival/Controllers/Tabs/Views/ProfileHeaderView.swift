//
//  ProfileHeaderView.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit
import SnapKit


class ProfileHeaderView: BaseView{
     private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
         imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "comicIcon")
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.textColor = .white
        label.text = "NICKNAME"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.blockColor
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "square.and.arrow.up",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 23)),
                        for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)

        button.tintColor = .white
        button.setTitle("Поделиться", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.imageView?.contentMode = .scaleAspectFit
        


        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.blockColor
        button.layer.cornerRadius = 20
        
        button.setImage(UIImage(systemName: "gear", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 23)),
                        for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)

        button.tintColor = .white
        button.setTitle("Настройки", for: .normal)
        return button
    }()
    
     lazy var createPostButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Resources.Colors.activeColor
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "plus",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 23)),
                        for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)

        button.tintColor = .white
        button.setTitle("Создать пост", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.imageView?.contentMode = .scaleAspectFit
        


        return button
    }()
    
    
    private lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.spacing = 15
         stackView.distribution = .fillEqually
         return stackView
     }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .left
        
        label.text = "Мне интересно происходящее тут"
        return label
    }()
    
    private lazy var userPostsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.text = "Осеки"
        label.numberOfLines = 0
        return label
    }()
    
    func configure(profileImage: UIImage, nickName: String){
        imageView.image = profileImage
        nickNameLabel.text = nickName.uppercased()
    }
    
    func setNickName(nickName: String){
        nickNameLabel.text = nickName.uppercased()
        userPostsLabel.text = "Осеки \(nickName.uppercased())"
    }
    
    func setProfileImage(profileImage: UIImage?){
        imageView.image = profileImage
    }
    
    func setGestureRecognizer(tap: UITapGestureRecognizer){
        imageView.addGestureRecognizer(tap)
    }
}

extension ProfileHeaderView{
    
    override func addViews(){
        super.addViews()
        addSubview(imageView)
        addSubview(nickNameLabel)
        addSubview(statusLabel)
        addSubview(verticalStackView)
        addSubview(userPostsLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(createPostButton)
        horizontalStackView.addArrangedSubview(shareButton)
        horizontalStackView.addArrangedSubview(settingsButton)
    }
    
    override func setUpConstraints(){
        super.setUpConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(350)
            make.centerX.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(imageView.snp.bottom).offset(15)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(115)
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(20
            )
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(20)
            make.leading.equalTo(nickNameLabel.snp.leading)
        }
        
        userPostsLabel.snp.makeConstraints { make in
            make.leading.equalTo(nickNameLabel.snp.leading)
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
        }
        
    }
    override func configure(){
        super.configure()
    }

}
