
//
//  SignUpViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import UIKit

class SignUpViewController: BaseViewController {
    private lazy var imageView : HeaderView = {
        let imageView = HeaderView()
        imageView.configure(type: .signUp)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
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
    
    private lazy var nickNameField : UITextField = {
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
        textField.attributedPlaceholder = NSAttributedString(string: "Придумайте никнейм", attributes: placeholderAttributes)
        textField.layer.cornerRadius = 12
        return textField
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
        textField.attributedPlaceholder = NSAttributedString(string: "Придумайте пароль", attributes: placeholderAttributes)
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private lazy var repeatPasswordField : UITextField = {
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
        textField.attributedPlaceholder = NSAttributedString(string: "Повторите пароль", attributes: placeholderAttributes)
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    
    private lazy var createAccountButton: UIButton = {
      let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Resources.Colors.activeColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(createAccountPressed), for: .touchUpInside)
        return button
    }()
}


extension SignUpViewController{
    override func addViews(){
        super.addViews()
        view.addSubview(imageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(nickNameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(repeatPasswordField)
        let spaceView = UIView()
        stackView.addArrangedSubview(spaceView)
        stackView.addArrangedSubview(createAccountButton)
    }
    override func setUpConstraints(){
        super.setUpConstraints()
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(150)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.42)
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
        
        emailField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        nickNameField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        passwordField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        repeatPasswordField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        createAccountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    override func configure(){
        super.configure()
    }
}

@objc extension SignUpViewController{
    func createAccountPressed(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let repeatedPassowd = repeatPasswordField.text, !repeatedPassowd.isEmpty,
              let nickname = nickNameField.text, !nickname.isEmpty,
              repeatedPassowd == password
        else{
            return
        }
        
        AuthManager.shared.signUp(email: email, password: password) { success in
            if success{
                let newUser = User(nickName: nickname, email: email, profileRef: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {return}
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(nickname, forKey: "nickname")

                    DispatchQueue.main.async{
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }
            }else{
                print("Smth went wrong, bratuha")
            }
        }
        
        
    }
}
