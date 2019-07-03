//
//  LoginViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/2/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class LoginViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var phoneNumberInput: TYInput!
    weak var passwordInput: TYInput!
    weak var forgotButton: UIButton!
    weak var errorLabel: UILabel!
    weak var container: UILayoutGuide!
    
    let number = "123"
    let password = "123"
    
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
        inputValid = !phoneNumberInput.isEmpty && !passwordInput.isEmpty
        print("input valid : \(inputValid)")
    }
    
    private func showError() {
        errorLabel.text = "Try number: 123, password: 123, ~~~~~~~~~~~~~~~~~~~~~~~~~`"
    }
    
    private func hideError() {
        errorLabel.text = ""
    }
    
    @objc func nextButtonTapped() {
        let numberText = phoneNumberInput.text
        let passwordText = passwordInput.text
        
        if numberText == number && passwordText == password {
            print("success!")
        } else {
            showError()
        }
    }
    
    @objc func forgotButtonTapped() {
        let phoneNumberViewController = PhoneNumberViewController(forgotFlow: true)
        navigationController?.pushViewController(phoneNumberViewController, animated: false)
    }
}

extension LoginViewController: TYInputDelegate {
    func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if input.textField is TYPhoneTextField {
            let allowInput = string.allSatisfy { $0.isNumber }
            if !allowInput {
                input.blink()
            }
            return allowInput
        }
        
        return true
    }
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        hideError()
        checkInputValid()
    }
}
