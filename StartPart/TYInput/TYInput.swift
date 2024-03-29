//
//  TYTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TYInputDelegate: class {
    @objc optional func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func input(_ input: TYInput, valueChangeTo string: String?)
    @objc optional func input(_ input: TYInput, selectedCountry country: Country)
}

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
    weak var delegate: TYInputDelegate?
    
    override func becomeFirstResponder() -> Bool {
        return textField!.becomeFirstResponder()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: nameLabel.intrinsicContentSize.width, height: 60)
    }
    
    //public
    public var label: String = ""
    
    public var text: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
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
            textField.bottomLineHeight = bottomLineHeight
        }
    }
    
    public var textFont: UIFont = TYInput.defaultTextFont {
        didSet {
            textField.font = textFont
        }
    }
    
    public var bottomLineColor: UIColor = TYInput.defaultBottomLineColor {
        didSet {
            textField.bottomLineColor = bottomLineColor
        }
    }
    
    public var isEmpty: Bool {
        return textField.text?.isEmpty ?? true
    }
    
    public func blink(to bottomLineColor: UIColor = .red) {
        self.bottomLineColor = bottomLineColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.bottomLineColor = TYInput.defaultBottomLineColor
        }
    }
    
    convenience init(frame: CGRect, label: String, type: TextFieldType = .normal, defaultSecure: Bool = false) {
        self.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width > 100 ? frame.size.width : 100, height: frame.size.height > 60 ? frame.size.height : 60))
        setup(with: label, type: type, defaultSecure: defaultSecure)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(with label: String, type: TextFieldType, defaultSecure: Bool) {
        
        let nameLabel = SpacingLabel(text: label, font: TYInput.defaultLabelFont)
        nameLabel.textColor = TYInput.defaultLabelColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.contentMode = .left
        self.nameLabel = nameLabel
        addSubview(nameLabel)
        
        
        let textField: TYNormalTextField
        
        switch type {
        case .normal:
            textField = TYNormalTextField()
        case .password:
            textField = TYPasswordTextField(frame: CGRect.zero, defaultSecure: defaultSecure)
        case .phone:
            textField = TYPhoneTextField()
            labelColor = UIColor(r: 79, g: 170, b: 248)
        }
        
        textField.clipsToBounds = true
        textField.font = TYInput.defaultTextFont
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        self.textField = textField
        addSubview(textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(countryChanged), name: UIResponder.countryChangedInPhoneTextFieldNotification, object: nil)
    }
    
    //Objc functions
    @objc func textFieldValueChanged(textField: UITextField) {
        if textField is TYPasswordTextField {
            textField.rightView?.isHidden = (textField.text ?? "").isEmpty
        }
        delegate?.input?(self, valueChangeTo: textField.text)
    }
    
    @objc func countryChanged(notification: Notification) {
        if let country = notification.userInfo?["country"] as? Country {
            delegate?.input?(self, selectedCountry: country)
        }
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
    
    enum TextFieldType {
        case normal, password, phone
    }
}

extension TYInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.input?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
