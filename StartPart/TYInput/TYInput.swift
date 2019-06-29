//
//  TYTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

class TYInput: UIView {
    
    internal static let defaultLabelColor: UIColor = .gray
    internal static let defaultTextColor: UIColor = .blue
    internal static let defaultBottomLineHeight: CGFloat = 1.2
    internal static let defaultBottomLineColor: UIColor = UIColor(red: 207/255.0, green: 212/255.0, blue: 217/255.0, alpha: 1)
    internal static let defaultTextFieldHeight: CGFloat = 32.0
    internal static let defaultLabelHeight: CGFloat = 20.0
    internal static let defaultLabelFont: UIFont = UIFont.avenirNext(bold: .medium, size: 14)
    internal static let defaultTextFont: UIFont = UIFont.avenirNext(bold: .medium, size: 17)
    
    var nameLabel: SpacingLabel!
    var textField: TYNormalTextField!
    
    override func becomeFirstResponder() -> Bool {
        return textField!.becomeFirstResponder()
    }
    
    //public
    public var label: String = "" {
        didSet {
            if oldValue == "" || label == "" {
                updateLayout(animate: true)
            }
        }
    }
    
    public var labelColor: UIColor = TYInput.defaultLabelColor {
        didSet {
            nameLabel.textColor = labelColor
        }
    }
    
    public var textColor: UIColor = TYInput.defaultTextColor {
        didSet {
            textField.textColor = textColor
        }
    }
    
    public var labelFont: UIFont = TYInput.defaultLabelFont {
        didSet {
            nameLabel.font = labelFont
        }
    }
    
    public var bottomLineHeight: CGFloat = TYInput.defaultBottomLineHeight {
        didSet {
            textField!.bottomLineHeight = bottomLineHeight
        }
    }
    
    public var textFont: UIFont = TYInput.defaultTextFont {
        didSet {
            textField!.font = textFont
        }
    }
    
    public var bottomLineColor: UIColor = TYInput.defaultBottomLineColor {
        didSet {
            textField!.bottomLineColor = bottomLineColor
        }
    }
    
    convenience init(frame: CGRect, label: String, type: TextFieldType = .normal) {
        self.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width > 100 ? frame.size.width : 100, height: frame.size.height > 60 ? frame.size.height : 60))
        setup(with: label, type: type)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(with label: String, type: TextFieldType) {
        
        let nameLabel = SpacingLabel(frame: CGRect.zero)
        nameLabel.text = label
        nameLabel.textColor = TYInput.defaultLabelColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.contentMode = .left
        nameLabel.font = TYInput.defaultLabelFont
        self.nameLabel = nameLabel
        addSubview(nameLabel)
        
        
        let textField: TYNormalTextField
        
        switch type {
        case .normal:
            textField = TYNormalTextField()
        case .password:
            textField = TYPasswordTextField()
        default:
            textField = TYPhoneTextField()
        }
        
        textField.clipsToBounds = true
        textField.font = TYInput.defaultTextFont
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField = textField
        addSubview(textField)
        
        
    }
    
    override func layoutSubviews() {
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: TYInput.defaultLabelHeight).isActive = true

        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: TYInput.defaultTextFieldHeight).isActive = true
    }
    
    private func updateLayout(animate: Bool) {
        let duration = 0.25
        if animate {
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    enum TextFieldType {
        case normal, password, phone
    }
}


