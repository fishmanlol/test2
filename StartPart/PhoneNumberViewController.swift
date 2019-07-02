//
//  PhoneNumberViewController.swift
//  StartPart
//
//  Created by tongyi on 6/30/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var phoneInput: TYInput!
    weak var remindLabel: SpacingLabel!
    weak var container: UILayoutGuide!
    var phoneNumberKit = PhoneNumberKit()
    var phoneNumber: PhoneNumber? {
        didSet {
            if phoneNumber == nil {
                inputValid = false
            } else {
                inputValid = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func viewsSetup() {
        let titleLabel = SpacingLabel(text: "What's your \nmobile number?", font: UIFont.avenirNext(bold: .medium, size: 24))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let phoneInput = TYInput(frame: CGRect.zero, label: "MOBILE NUMBER", type: .phone)
        self.phoneInput = phoneInput
        view.addSubview(phoneInput)
        
        let remindLabel = SpacingLabel(text: "We'll send you an SMS verification code.", spacing: 0.5, font: UIFont.avenirNext(bold: .regular, size: 12))
        remindLabel.numberOfLines = 0
        self.remindLabel = remindLabel
        view.addSubview(remindLabel)
        
        let container = UILayoutGuide()
        self.container = container
        view.addLayoutGuide(container)
    }
    
    private func viewsLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(container)
        }
        
        phoneInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        container.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(60)
        }
        
        remindLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(phoneInput.snp.bottom).offset(6)
        }
    }
    
    private func setup() {
        phoneInput.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func remindError() {
        remindLabel.updateColor(to: .red)
        remindLabel.text = "This mobile number is not available"
    }
    
    private func restoreRemind() {
        remindLabel.updateColor(to: .black)
        remindLabel.text = "We'll send you an SMS verification code."
    }
    
    private func sendVerification(phoneNumber: PhoneNumber, completion: (Bool) -> Void) {
        let success = Bool.random()
        completion(success)
    }
    
    @objc func nextButtonTapped() {
        guard let phoneNumber = self.phoneNumber else { return }
        sendVerification(phoneNumber: phoneNumber) { success in
            if success {
                let phoneVerificationViewController = PhoneVerificationViewController(phoneNumber: phoneNumber, phoneNumberKit: phoneNumberKit)
                navigationController?.pushViewController(phoneVerificationViewController, animated: false)
            } else {
                remindError()
                self.phoneNumber = nil
            }
        }
    }
    
}

extension PhoneNumberViewController: TYInputDelegate {
    func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        restoreRemind()
        if let phoneTextField = input.textField as? TYPhoneTextField {
            let selectedCountry = phoneTextField.selectedCountry
            let numberToFormat = (string ?? "").onlyNumber
            //if parse correctly
            if let phoneNumber = try? phoneNumberKit.parse(numberToFormat, withRegion: selectedCountry.id, ignoreType: true) {
                let numberFormatted = phoneNumberKit.format(phoneNumber, toType: .national, withPrefix: false)
                //sometimes formatter will automatically convert our input to most possible number, but we don't want to change use's input.
                //if input: 9491313313, formatter give us (949) 131-3313
                //if input: 94913133130, formatter give us 0913 133 130
                //we compare first 3 number to decide whether we need this format
                let numberFormattedFiltered = numberFormatted.onlyNumber
                let commonPrefix = numberFormattedFiltered.commonPrefix(with: numberToFormat)
                if commonPrefix.count > 2 {
                    //we need display this formatted number and save
                    self.phoneNumber = phoneNumber
                    input.textField.text = numberFormatted
                } else {
                    //discard
                    self.phoneNumber = nil
                    input.textField.text = numberToFormat
                }
                print(numberFormatted)
                print(input.text)
            } else { //parse error, which means this phone number is not valid
                self.phoneNumber = nil
                input.textField.text = numberToFormat
            }
        }
    }
    
    func input(_ input: TYInput, selectedCountry country: Country) {
        self.input(input, valueChangeTo: input.text)
    }
}
