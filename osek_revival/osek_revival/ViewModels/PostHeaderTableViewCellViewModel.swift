//
//  PostHeaderTableViewCellViewModel.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 07.05.2024.
//

import Foundation
import UIKit

class PostHeaderTableViewCellViewModel{
    var imageURL: URL?
    var imageData: Data?
    init(imageURL: URL? = nil) {
        self.imageURL = imageURL
    }
}
