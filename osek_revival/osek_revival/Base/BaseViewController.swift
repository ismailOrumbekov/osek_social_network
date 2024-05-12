//
//  BaseViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit

class BaseViewController: UIViewController{
    override func viewDidLoad() {
        setUpUI()
    }
}


@objc extension BaseViewController{
    func setUpUI(){
        addViews()
        setUpConstraints()
        configure()
    }
    
    func addViews(){
        
    }
    
    func setUpConstraints(){
        
    }
    
    func configure(){
        
    }
}

//    override func addViews(){
//        super.addViews()
//    }
//    override func setUpConstraint(){
//        super.setUpConstraint()
//    }
//    override func configure(){
//        super.configure()
//    }
