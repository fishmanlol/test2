//
//  TYCoreTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class TYNormalTextField: UITextField {
    
    var bottomLineHeight: CGFloat = TYInput.defaultBottomLineHeight {
        didSet {
            bottomLine?.frame = CGRect(x: 0, y: height, width: width, height: bottomLineHeight)
        }
    }

    var bottomLineColor: UIColor = TYInput.defaultBottomLineColor {
        didSet {
            bottomLine?.backgroundColor = bottomLineColor.cgColor
        }
    }

    private var bottomLine: CALayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        defaultTextAttributes.updateValue(1.3, forKey: NSAttributedString.Key.kern)
        contentVerticalAlignment = .center
        autocorrectionType = .no
        addBottomLine()
    }

    private func addBottomLine() {
        let bottomLine = CALayer()
        self.bottomLine = bottomLine
        bottomLine.backgroundColor = bottomLineColor.cgColor
        layer.addSublayer(bottomLine)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine?.frame = CGRect(x: 0, y: height - bottomLineHeight, width: width, height: bottomLineHeight)
    }
}


