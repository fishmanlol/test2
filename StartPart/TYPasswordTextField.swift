//
//  TYPasswordTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class TYPasswordTextField: TYNormalTextField {
    weak var hideButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.setImage(UIImage(named: "eye_slash"), for: .selected)
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        self.hideButton = button
        
        leftView = hideButton
    }
    
    @objc func toggleButtonTapped(button: UIButton) {
        button.isSelected = !button.isSelected
        hideText(button.isSelected)
    }
    
    private func hideText(_ hide: Bool) {
        isSecureTextEntry = hide ? true : false
    }
}
