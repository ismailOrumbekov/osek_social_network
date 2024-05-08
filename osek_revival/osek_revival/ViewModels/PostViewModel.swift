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
    let imageURL: URL?
    var imageData: Data?
    var description: String?
    
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
    
    init(title: String, imageURL: URL?, description: String) {
        self.title = title
        self.imageURL = imageURL
        self.description = description
    }
}
