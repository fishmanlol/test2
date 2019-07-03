//
//  NewPasswordViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/2/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: FlowBaseViewController {
    
    weak var titleLabel: UILabel!
    weak var titleDetailLabel: UILabel!
    weak var errorLabel: UILabel!
    weak var passwordInput: TYInput!
    weak var confirmInput: TYInput!
    weak var container: UILayoutGuide!
    
    lazy var HUD: SimpleHUD = {
        let HUD = SimpleHUD(labelString: "One Moment...")
        HUD.alpha = 0
        return HUD
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func viewsSetup() {
        let titleLabel = SpacingLabel(text: "New password", font: UIFont.avenirNext(bold: .medium, size: 24))
        titleLabel.textAlignment = .center
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let titleDetailLabel = SpacingLabel(text: "Your password should be at least 8 characters", font: UIFont.avenirNext(bold: .regular, size: 14))
        titleDetailLabel.updateColor(to: TYInput.defaultLabelColor)
        titleDetailLabel.textAlignment = .center
        titleDetailLabel.numberOfLines = 0
        self.titleDetailLabel = titleDetailLabel
        view.addSubview(titleDetailLabel)
        
        let passwordInput = TYInput(frame: CGRect.zero, label: "NEW PASSWORD", type: .password, defaultSecure: true)
        self.passwordInput = passwordInput
        view.addSubview(passwordInput)
        
        let confirmInput = TYInput(frame: CGRect.zero, label: "CONFIRM PASSWORD", type: .password, defaultSecure: true)
        self.confirmInput = confirmInput
        view.addSubview(confirmInput)
        
        let errorLabel = SpacingLabel(text: "", spacing: 0.5, font: UIFont.avenirNext(bold: .regular, size: 12))
        errorLabel.numberOfLines = 0
        errorLabel.updateColor(to: .red)
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
        
        confirmInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(passwordInput.snp.bottom).offset(18)
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(confirmInput.snp.bottom).offset(6)
        }
        
        container.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(60)
        }
    }
    
    private func setup() {
        passwordInput.delegate = self
        confirmInput.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func checkInputValid() {
        inputValid = passwordInput.text.count > 7 && confirmInput.text.count > 7
    }
    
    private func allowInput(_ string: String) -> Bool {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!@#$%^&*()~`?"))
        return string.unicodeScalars.allSatisfy { allowedCharacterSet.contains($0) }
    }
    
    private func checkPassword(completion: (Bool, String?) -> Void) {
        let newPassword = passwordInput.text
        let confirm = confirmInput.text
        
        guard newPassword .count > 7 else {
            completion(false, "Password shoud be at least 8 characters")
            return
        }
        
        guard newPassword == confirm else {
            completion(false, "Confirm password is not matched")
            return
        }
        
        completion(true, nil)
    }
    
    private func showError(_ error: String?) {
        errorLabel.text = error
    }
    
    private func hideError() {
        errorLabel.text = ""
    }
    
    private func showHUD() {
        view.addSubview(HUD)
        UIView.animate(withDuration: 0.15) {
            self.HUD.alpha = 1
        }
    }
    
    private func hideHUD() {
        UIView.animate(withDuration: 0.15, animations: {
            self.HUD.alpha = 0
        }) { (_) in
            self.HUD.removeFromSuperview()
        }
    }
    
    private func updatePassword(_ password: String, completion: @escaping (Bool, String?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if password == "12345678" {
                completion(true, nil)
            } else {
                completion(false, "You should try 12345678")
            }
        }
    }
    
    @objc func nextButtonTapped() {
        let password = passwordInput.text
        checkPassword() { (correct, message) in
            if correct {
                self.showHUD()
                updatePassword(password) { (correct, message) in
                    self.hideHUD()
                    if correct { //go to finish forgot password page
                        let finish = FinishViewController()
                        self.navigationController?.pushViewController(finish, animated: false)
                    } else { //show error
                        self.showError(message)
                    }
                }
            } else {
                showError(message)
            }
        }
    }
    
    override func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension UpdatePasswordViewController: TYInputDelegate {
    func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isAllowed = allowInput(string)
        if !isAllowed {
            input.blink()
        }
        return isAllowed
    }
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        hideError()
        checkInputValid()
    }
}
