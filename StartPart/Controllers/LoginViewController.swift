//
//  LoginViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/2/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import PhoneNumberKit

class LoginViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var phoneNumberInput: TYInput!
    weak var passwordInput: TYInput!
    weak var forgotButton: UIButton!
    weak var errorLabel: UILabel!
    weak var container: UILayoutGuide!
    
    let phoneNumberKit = PhoneNumberKit()
    var phoneNumber: PhoneNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func setup() {
        phoneNumberInput.delegate = self
        passwordInput.delegate = self
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.kern: 1.3]
        nextButton.setAttributedTitle(NSAttributedString(string: "Log In", attributes: attributes), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func viewsSetup() {
        let container = UILayoutGuide()
        self.container = container
        view.addLayoutGuide(container)
        
        let titleLabel = SpacingLabel(text: "Log In", font: UIFont.avenirNext(bold: .medium, size: 24))
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let phoneNumberInput = TYInput(frame: CGRect.zero, label: "MOBILE NUMBER", type: .phone)
        self.phoneNumberInput = phoneNumberInput
        view.addSubview(phoneNumberInput)
        
        let passwordInput = TYInput(frame: CGRect.zero, label: "PASSWORD", type: .password)
        self.passwordInput = passwordInput
        view.addSubview(passwordInput)
        
        let errorLabel = SpacingLabel(text: "", spacing: 0.5, font: UIFont.avenirNext(bold: .regular, size: 12))
        errorLabel.numberOfLines = 0
        errorLabel.updateColor(to: .red)
        self.errorLabel = errorLabel
        view.addSubview(errorLabel)
        
        let forgotButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(r: 0, g: 122, b: 255), NSAttributedString.Key.font: UIFont.avenirNext(bold: .regular, size: 14), NSAttributedString.Key.kern: 0.2]
        forgotButton.setAttributedTitle(NSAttributedString(string: "Forgot your password?", attributes: attributes), for: .normal)
        forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        self.forgotButton = forgotButton
        view.addSubview(forgotButton)
    }
    
    private func viewsLayout() {
        container.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(60)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalTo(container)
        }
        
        phoneNumberInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.height.equalTo(60)
        }
        
        passwordInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(phoneNumberInput.snp.bottom).offset(18)
            make.height.equalTo(60)
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(passwordInput.snp.bottom).offset(6)
        }
        
        forgotButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(container)
            make.top.equalTo(errorLabel.snp.bottom).offset(14)
        }
    }
    
    private func checkInputValid() {
        inputValid = phoneNumber != nil && !passwordInput.isEmpty
        print("input valid : \(inputValid)")
    }
    
    private func showError() {
        errorLabel.text = "Error happens, please try again"
    }
    
    private func hideError() {
        errorLabel.text = ""
    }
    
    @objc func nextButtonTapped() {
        guard let phoneNumebr = phoneNumber else { return }
        let numberText = "+\(phoneNumebr.countryCode) \(phoneNumebr.nationalNumber)"
        let passwordText = passwordInput.text
        
        displayHUD()
        APIService.shared.login(phoneNumber: numberText, password: passwordText) { (success, resultData) in
            self.removeHUD()
            guard success, let resultData = resultData else {
                self.showError()
                return
            }
            
            print("success!!!!!!!!!!!!!!!Login!!!!")
        }
    }
    
    @objc func forgotButtonTapped() {
        let phoneNumberViewController = PhoneNumberViewController(forgotFlow: true)
        navigationController?.pushViewController(phoneNumberViewController, animated: false)
    }
}

extension LoginViewController: TYInputDelegate {
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        hideError()
        
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

            } else { //parse error, which means this phone number is not valid
                self.phoneNumber = nil
                input.textField.text = numberToFormat
            }
        }
        
        checkInputValid()
    }
    
    func input(_ input: TYInput, selectedCountry country: Country) {
        self.input(input, valueChangeTo: input.text)
    }
}
