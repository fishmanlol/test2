//
//  PasswordController.swift
//  StartPart
//
//  Created by tongyi on 6/30/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class PasswordViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var titleDetailLabel: UILabel!
    weak var errorLabel: UILabel!
    weak var passwordInput: TYInput!
    weak var container: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func viewsSetup() {
        let titleLabel = SpacingLabel(text: "Set a password", font: UIFont.avenirNext(bold: .medium, size: 24))
        titleLabel.textAlignment = .center
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let titleDetailLabel = SpacingLabel(text: "Your password should be at least 8 characters", font: UIFont.avenirNext(bold: .regular, size: 14))
        titleDetailLabel.updateColor(to: TYInput.defaultLabelColor)
        titleDetailLabel.textAlignment = .center
        titleDetailLabel.numberOfLines = 0
        self.titleDetailLabel = titleDetailLabel
        view.addSubview(titleDetailLabel)
        
        let passwordInput = TYInput(frame: CGRect.zero, label: "PASSWORD", type: .password)
        self.passwordInput = passwordInput
        view.addSubview(passwordInput)
        
        let errorLabel = SpacingLabel(text: "Your password must be at least 8 characters.")
        errorLabel.isHidden = false
        errorLabel.textColor = .red
        self.errorLabel = errorLabel
        view.addSubview(errorLabel)
        
        let container = UILayoutGuide()
        self.container = container
        view.addLayoutGuide(container)
    }
    
    private func viewsLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(container)
        }
        
        titleDetailLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        passwordInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleDetailLabel.snp.bottom).offset(36)
        }
        
        container.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(180)
            make.left.equalToSuperview().offset(60)
        }
    }
    
    private func setup() {
        passwordInput.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func checkInputValid() {
        inputValid = passwordInput.text.count > 7
    }
    
    private func allowInput(_ string: String) -> Bool {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!@#$%^&*()~`?"))
        return string.unicodeScalars.allSatisfy { allowedCharacterSet.contains($0) }
    }
    
    @objc func nextButtonTapped() {
        let phoneNumberViewController = PhoneNumberViewController()
        navigationController?.pushViewController(phoneNumberViewController, animated: false)
    }
}

extension PasswordViewController: TYInputDelegate {
    func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isAllowed = allowInput(string)
        if !isAllowed {
            input.blink()
        }
        return isAllowed
    }
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        checkInputValid()
    }
}
