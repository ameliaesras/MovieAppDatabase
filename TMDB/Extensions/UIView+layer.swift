//
//  UIView+layer.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}
