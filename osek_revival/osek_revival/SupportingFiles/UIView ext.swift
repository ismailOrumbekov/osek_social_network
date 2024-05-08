//
//  UIView ext.swift
//  osek_revival
//
//  Created by Исмаил Орумбеков on 08.05.2024.
//

import Foundation
import UIKit

extension UIView {
func addoverlay(color: UIColor = .black,alpha : CGFloat = 0.6) {
    let overlay = UIView()
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.frame = CGRect(x: 0, y: self.bounds.maxY - 100, width: self.bounds.width, height: 100)
    overlay.backgroundColor = color
    overlay.alpha = alpha
    addSubview(overlay)
    }
}
