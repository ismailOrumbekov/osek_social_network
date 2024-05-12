//
//  Post.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit

struct Post{
    let identigier: String
    let title: String
    let timestamp: TimeInterval
    let headerImageUrl: URL?
    let text: String
    let author: User?
    
}
