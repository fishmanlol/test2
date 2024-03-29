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
    lazy var HUD: SimpleHUD = {
        let HUD = SimpleHUD(labelString: "Verifying...")
        HUD.alpha = 0
        return HUD
    }()
    
    let phoneNumber: PhoneNumber
    let phoneNumberKit: PhoneNumberKit
    let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.kern: 1.3]
    
    var lastSend: Date!
    var timer: Timer?
    var forgotFlow = false
    var registrationInfo: RegistrationInfo?
    
    init(phoneNumber: PhoneNumber, phoneNumberKit: PhoneNumberKit, lastSend: Date, forgotFlow: Bool = false, registrationInfo: RegistrationInfo? = nil) {
        self.phoneNumber = phoneNumber
        self.phoneNumberKit = phoneNumberKit
        self.lastSend = lastSend
        self.forgotFlow = forgotFlow
        self.registrationInfo = registrationInfo
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelTapped))
        descriptionLabel.addGestureRecognizer(tap)
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.textColor = TYInput.defaultBottomLineColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        self.descriptionLabel = descriptionLabel
        view.addSubview(descriptionLabel)
        
        let nameLabel = SpacingLabel(text: "CODE", font: TYInput.defaultLabelFont)
        nameLabel.updateColor(to: UIColor(r: 79, g: 170, b: 248))
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
        pinCodeTextField.keyboardType = .phonePad
        self.pinCodeTextField = pinCodeTextField
        view.addSubview(pinCodeTextField)
        
        let errorLabel = SpacingLabel(text: "Error happens, please try later.", spacing: 0.5, font: UIFont.avenirNext(bold: .regular, size: 12))
        errorLabel.isHidden = true
        errorLabel.updateColor(to: UIColor.red)
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
            make.height.equalTo(70)
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
    
    private func beginCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkLastSend), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func setup() {
        nextButton.setAttributedTitle(NSAttributedString(string: "Resend", attributes: attributes), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        beginCountdown()
    }
    
    private func handleCodeError() {
        showErrorLabel()
        self.pinCodeTextField.becomeFirstResponder()
    }
    
    private func handleCodeCorrect() {
        if forgotFlow { //go to update password page
            let phoneNumberString = "+\(phoneNumber.countryCode) \(phoneNumber.nationalNumber)"
            let updatePasswordController = UpdatePasswordViewController(phoneNumber: phoneNumberString, verificationCode: pinCodeTextField.text!)
            navigationController?.pushViewController(updatePasswordController, animated: false)
        } else { //finish register
            let finishViewController = FinishViewController()
            navigationController?.pushViewController(finishViewController, animated: false)
        }
    }
    
    private func hideErrorLabel() {
        errorLabel.isHidden = true
    }
    
    private func showErrorLabel() {
        errorLabel.isHidden = false
    }
    
    private func validate(code: String) {
        displayHUD()
        
        let phoneNumberString = "+\(phoneNumber.countryCode) \(phoneNumber.nationalNumber)"
        if forgotFlow { //forgot password flow
            APIService.shared.login(phoneNumber: phoneNumberString, verificationCode: code) { (success, resultData) in
                self.removeHUD()
                
                if success {
                    self.handleCodeCorrect()
                } else {
                    self.handleCodeError()
                }
            }
            
        } else { //registration flow
            guard let password = registrationInfo?.password, let firstName = registrationInfo?.firstName, let lastName = registrationInfo?.lastName else {
                removeHUD()
                handleCodeError()
                return
            }
            
            APIService.shared.register(phoneNumber: phoneNumberString, verificationCode: code, password: password, firstName: firstName, middleName: registrationInfo?.middleName, lastName: lastName) { (success, resultData) in
                self.removeHUD()
                
                if success {
                    self.handleCodeCorrect()
                } else {
                    self.handleCodeError()
                }
            }
            
        }
    }
    
    private func sendVerification() {
        displayHUD()
        let phoneNumberString = "+\(phoneNumber.countryCode) \(phoneNumber.nationalNumber)"
        APIService.shared.sendVerficationCode(phoneNumber: phoneNumberString) { (success) in
            self.removeHUD()
            self.inputValid = false
            if success {
                self.beginCountdown()
                self.hideErrorLabel()
            } else {
                self.showErrorLabel()
            }
        }
    }
    
    private func changeNextButtonWithoutAnimation(title: String) {
        UIView.setAnimationsEnabled(false)
        nextButton.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        nextButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    @objc func nextButtonTapped() {
        lastSend = Date()
        sendVerification()
    }
    
    @objc func checkLastSend() {
        let interval = Int(abs(lastSend.timeIntervalSinceNow))
        if interval > 9 {
            timer?.invalidate()
            timer = nil
            changeNextButtonWithoutAnimation(title: "Resend")
            inputValid = true
        } else {
            let remain = 10 - interval
            changeNextButtonWithoutAnimation(title: "Resend(\(remain)s)")
        }
    }
    
    @objc func descriptionLabelTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print(#function)
    }
    
}

extension PhoneVerificationViewController: PinCodeTextFieldDelegate {
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        hideErrorLabel()
        
        let digits = textField.text?.count ?? 0
        if digits == textField.characterLimit { //complete input
            validate(code: textField.text!)
        }
    }
}
