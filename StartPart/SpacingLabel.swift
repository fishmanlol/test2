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
    
    convenience init(frame: CGRect, spacing: CGFloat = 1.2) {
        self.init(frame: frame)
        attributes = [NSAttributedString.Key.kern: spacing]
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
