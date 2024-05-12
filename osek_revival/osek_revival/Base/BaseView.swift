//
//  BaseView.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit

class BaseView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension BaseView{
    func setUpUI(){
        addViews()
        setUpConstraints()
        configure()
    }
    func addViews(){}
    func setUpConstraints(){}
    func configure(){
    }
    
//    override func addViews(){
//        super.addViews()
//    }
//    override func setUpConstraints(){
//        super.setUpConstraint()
//    }
//    override func configure(){
//        super.configure()
//    }

}

