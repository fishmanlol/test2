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
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "123"), object: nil, userInfo: ["keyboardHeight": keyboardHeight])
        }
    }
    static let shared = KeyboardService()
    
    static func startWork() {
        shared.invokeKeyboard()
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func invokeKeyboard() {
        let textField = UITextField()
        UIApplication.shared.windows.last?.addSubview(textField)
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            KeyboardService.keyboardHeight = value.cgRectValue.height
        }
    }
}
