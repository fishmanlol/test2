//
//  AvenirLabel.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class SpacingLabel: UILabel {
    
    var attributes: [NSAttributedString.Key: Any] = [:]
    
    override var text: String? {
        didSet {
            if text != nil || !text!.isEmpty {
                attributedText = NSAttributedString(string: text!, attributes: attributes)
            }
        }
    }
    
    convenience init(text: String, spacing: CGFloat = 1.3, font: UIFont = UIFont.avenirNext(bold: .regular, size: 17)) {
        self.init(frame: CGRect.zero)
        attributes = [NSAttributedString.Key.kern: spacing, NSAttributedString.Key.font: font]
        self.text = text
    }
    
    public func updateColor(to color: UIColor) {
        attributes[NSAttributedString.Key.foregroundColor] = color
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    private init() {
        super.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
