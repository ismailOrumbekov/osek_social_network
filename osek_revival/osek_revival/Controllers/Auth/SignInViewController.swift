//
//  SignInViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit

class SignInViewController: BaseViewController{
    private lazy var headerView: HeaderView = {
        let header = HeaderView()
        header.configure(type: .singIn)
        return header
    }()
    
    private lazy var emailField : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = Resources.Colors.passiveColor
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray
            ]
        textField.attributedPlaceholder = NSAttributedString(string: "Введите почту", attributes: placeholderAttributes)    
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var passwordField : UITextField = {
       let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = Resources.Colors.passiveColor
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray
            ]
        textField.attributedPlaceholder = NSAttributedString(string: "Введите пароль", attributes: placeholderAttributes)
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
      let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Resources.Colors.activeColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("Создать аккаунт", for: .normal)
        button.setTitleColor(Resources.Colors.activeColor, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(createAccountPressed), for: .touchUpInside)
        return button
    }()
}

extension SignInViewController{
    override func addViews(){
        super.addViews()
        view.addSubview(headerView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        stackView.addArrangedSubview(spaceView)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(createAccountButton)

    }
    override func setUpConstraints(){
        super.setUpConstraints()
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(headerView.snp.bottom).offset(50)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        emailField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        headerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }

    }
    override func configure(){
        super.configure()
        view.backgroundColor = .black
    }
}


@objc extension SignInViewController{
    func signInPressed(){
       guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else{return}
        print(password)

        AuthManager.shared.signIn(email: email, password: password) { success in
            guard success else {
                print("chto-to ne tak suka")
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            DispatchQueue.main.async{
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            
        }
    }
    
    func createAccountPressed(){
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
