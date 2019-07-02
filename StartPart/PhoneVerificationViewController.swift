//
//  PhoneVerificationViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/1/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import PinCodeTextField
import PhoneNumberKit

class PhoneVerificationViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var descriptionLabel: UILabel!
    weak var inputContainer: UILayoutGuide!
    weak var nameLabel: UILabel!
    weak var pinCodeTextField: PinCodeTextField!
    weak var container: UILayoutGuide!
    weak var errorLabel: UILabel!
    
    let phoneNumber: PhoneNumber
    let phoneNumberKit: PhoneNumberKit
    
    init(phoneNumber: PhoneNumber, phoneNumberKit: PhoneNumberKit) {
        self.phoneNumber = phoneNumber
        self.phoneNumberKit = phoneNumberKit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.phoneNumber = PhoneNumber.notPhoneNumber()
        self.phoneNumberKit = PhoneNumberKit()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func viewsSetup() {
        let titleLabel = SpacingLabel(text: "Enter Confirmation Code", font: UIFont.avenirNext(bold: .medium, size: 24))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .international)
        let descriptionLabel = SpacingLabel(text: formattedNumber, spacing: 0.5, font: UIFont.avenirNext(bold: .medium, size: 15))
        descriptionLabel.textColor = TYInput.defaultBottomLineColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        self.descriptionLabel = descriptionLabel
        view.addSubview(descriptionLabel)
        
        let nameLabel = SpacingLabel(text: "CODE")
        self.nameLabel = nameLabel
        view.addSubview(nameLabel)
        
        let pinCodeTextField = PinCodeTextField()
        pinCodeTextField.needToUpdateUnderlines = true
        pinCodeTextField.characterLimit = 6
        pinCodeTextField.font = UIFont.avenirNext(bold: .medium, size: 24)
        pinCodeTextField.underlineHeight = 1.5
        pinCodeTextField.text = ""
        pinCodeTextField.allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        pinCodeTextField.becomeFirstResponder()
        pinCodeTextField.delegate = self
        pinCodeTextField.textColor = .black
        pinCodeTextField.keyboardType = .numberPad
        self.pinCodeTextField = pinCodeTextField
        view.addSubview(pinCodeTextField)
        
        let errorLabel = SpacingLabel(text: "Pin Code is not correct.")
        self.errorLabel = errorLabel
        view.addSubview(errorLabel)
        
        let inputContainer = UILayoutGuide()
        self.inputContainer = inputContainer
        view.addLayoutGuide(inputContainer)
        
        let container = UILayoutGuide()
        self.container = container
        view.addLayoutGuide(container)
    }
    
    private func viewsLayout() {
        
        container.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(60)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(container)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        inputContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(inputContainer)
        }
        
        pinCodeTextField.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(inputContainer)
            make.height.equalTo(30)
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(inputContainer.snp.bottom).offset(6)
        }
    }
    
    private func setup() {
        
    }
    
}

extension PhoneVerificationViewController: PinCodeTextFieldDelegate {
}
