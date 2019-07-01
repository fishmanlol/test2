//
//  KeyBoardService.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

class KeyboardService {
    static var keyboardHeight: CGFloat = 0 {
        didSet {
            print("Keyboard height now is: \(keyboardHeight)")
            NotificationCenter.default.post(name: UIResponder.keyboardWillChangeHeightNotification, object: nil, userInfo: ["keyboardHeight": keyboardHeight])
        }
    }
    static let shared = KeyboardService()
    
    static func startWork() {
        shared.invokeKeyboard()
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func invokeKeyboard() {
        let textField = UITextField()
        textField.autocorrectionType = .no
        UIApplication.shared.windows.last?.addSubview(textField)
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            value.cgRectValue.minY < UIScreen.main.bounds.maxY {
            KeyboardService.keyboardHeight = value.cgRectValue.height
        }
    }
}
