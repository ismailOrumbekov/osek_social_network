//
//  PostPreviewTableViewCellViewModel.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit

class PostViewModel{
    let title: String
    let postImageURL: URL?
    var postImageData: Data?
    var description: String?
    
    var author: User
    
    
    init(title: String, imageURL: URL?, user: User) {
        self.title = title
        self.postImageURL = imageURL
        self.author = user
        
    }
    
    init(title: String, imageURL: URL?, description: String, user: User) {
        self.title = title
        self.postImageURL = imageURL
        self.description = description
        self.author = user

    }
}
