//
//  TYPasswordTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class TYPasswordTextField: TYNormalTextField {
    
    var defaultSecure: Bool = false
    
    init(frame: CGRect, defaultSecure: Bool = false) {
        super.init(frame: frame)
        self.defaultSecure = defaultSecure
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        let button = UIButton()
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: TYInput.defaultBottomLineColor, NSAttributedString.Key.font: TYInput.defaultTextFont]
        let attributedHide = NSAttributedString(string: "hide", attributes: attributes)
        let attributedShow = NSAttributedString(string: "show", attributes: attributes)
        
        button.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        button.setAttributedTitle(attributedHide, for: .normal)
        button.setAttributedTitle(attributedShow, for: .selected)
        button.frame.size = attributedShow.size()
        
        rightView = button
        rightView?.isHidden = true
        rightViewMode = .always
        
        if defaultSecure {
            toggleButtonTapped(button: button)
        }
    }
    
    @objc func toggleButtonTapped(button: UIButton) {
        button.isSelected = !button.isSelected
        hideText(button.isSelected)
    }
    
    func hideText(_ hide: Bool) {
        isSecureTextEntry = hide ? true : false
    }
}
