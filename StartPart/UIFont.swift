//
//  UIFont.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {
    static func avenirNext(bold: Bold, size: CGFloat) -> UIFont {
        switch bold {
        case .medium:
            return UIFont(name: "AvenirNext-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .regular:
            return UIFont(name: "AvenirNext-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    enum Bold {
        case regular, medium
    }
}
