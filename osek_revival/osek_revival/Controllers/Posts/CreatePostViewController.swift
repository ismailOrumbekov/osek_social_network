//
//  CreatePostViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import UIKit

class CreatePostViewController: BaseViewController {
    var onPostSuccess: (() -> Void)?

    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.tintColor = Resources.Colors.passiveColor
    
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private var selectedImage: UIImage?
    
    private lazy var titleField : UITextField = {
       let textField = UITextField()
        textField.backgroundColor = Resources.Colors.passiveColor
        textField.textColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray
            ]
        textField.attributedPlaceholder = NSAttributedString(string: "Придумайте заголовок", attributes: placeholderAttributes)
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 23)
        textView.textColor = .white
        textView.layer.cornerRadius = 15
        textView.backgroundColor = Resources.Colors.passiveColor
        return textView
    }()
    
    private func showAlert(){
        let alert = UIAlertController(title: "Упс", message: "Вам нужно заполнить все данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понял", style: .cancel))
        present(alert, animated: true)
    }
}


//MARK: UI set ups
extension CreatePostViewController{
    override func addViews(){
        super.addViews()
        view.addSubview(imageView)
        view.addSubview(titleField)
        view.addSubview(textView)
    }
    override func setUpConstraints(){
        super.setUpConstraints()
        
        titleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        textView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-20)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    override func configure(){
        super.configure()
        view.backgroundColor = Resources.Colors.activeBackgroundColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(cancelPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выложить",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(postPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
    }

}


//MARK: Selectors
@objc extension CreatePostViewController{
    func cancelPressed(){
        dismiss(animated: true)
    }
    
    func postPressed(){
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty,
              let body = textView.text, !body.trimmingCharacters(in: .whitespaces).isEmpty,
              let image = selectedImage,
              let email = UserDefaults.standard.string(forKey: "email")
        else{
            showAlert()
            return
        }
        
        print("Entering")
        let postId = UUID().uuidString
        
        StorageManager.shared.uploadPostHeaderImage(
        email: email,
        image: image,
        postId: postId
        ){ success in
            guard success else {return}
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: postId) { url in
                guard let headerUrl = url else {
                    print("Failed to upload url")
                    return
                }
                
                let post = Post(
                    identigier: postId,
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageUrl: headerUrl,
                    text: body,
                    author: nil)
                
                DatabaseManager.shared.insert(post: post, email: email) {[weak self] success in
                    guard success else {
                        print("failed to upload post")
                        return
                    }
                    
                    self?.dismiss(animated: true)
                    self?.onPostSuccess?()

                    
                }
            }
            
            
        }
        
        
        
    }
    
    func didTapImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        present(picker, animated: true)
    }
}


//MARK: Image picker set ups

extension CreatePostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {return}
        selectedImage = image
        imageView.image = image
    }
}
