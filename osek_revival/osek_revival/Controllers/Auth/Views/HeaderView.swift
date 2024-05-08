//
//  HeaderView.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit
import SnapKit

class HeaderView: BaseView{
    enum HeaderType{
        case singIn
        case signUp
    }
    var type = HeaderType.singIn
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func configure(type: HeaderType){
        switch type{
        case .signUp:
            imageView.image = UIImage(named: "secret")
            titleLabel.text = "Регистрация"
            self.type = .signUp
            
        case .singIn:
            imageView.image = UIImage(named: "hackerIcon")
            titleLabel.text = "Войти в аккаунт"
        }
        
        
    }
    
    
}

extension HeaderView{
    
    override func addViews(){
        super.addViews()
        addSubview(imageView)
        addSubview(titleLabel)
    }
    override func setUpConstraints(){
        super.setUpConstraints()
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    override func configure(){
        super.configure()
    }
    
}
