//
//  NameViewController.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class NameViewController: FlowBaseViewController {

    weak var titleLabel: UILabel!
    weak var agreementTextView: UITextView!
    weak var firstNameInput: TYInput!
    weak var lastNameInput: TYInput!
    weak var container: UILayoutGuide!
    
    var registrationInfo: RegistrationInfo!
    
    init(registrationInfo: RegistrationInfo) {
        super.init(nibName: nil, bundle: nil)
        self.registrationInfo = registrationInfo
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func setup() {
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.kern: 1.3]
        nextButton.setAttributedTitle(NSAttributedString(string: "Sign Up & Accept", attributes: attributes), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func viewsSetup() {
        let container = UILayoutGuide()
        self.container = container
        view.addLayoutGuide(container)
        
        let titleLabel = SpacingLabel(text: "What's your name?", font: UIFont.avenirNext(bold: .medium, size: 24))
        self.titleLabel = titleLabel
        view.addSubview(titleLabel)
        
        let firstNameInput = TYInput(frame: CGRect.zero, label: "FIRST NAME", type: .normal)
        self.firstNameInput = firstNameInput
        view.addSubview(firstNameInput)
        
        let lastNameInput = TYInput(frame: CGRect.zero, label: "LAST NAME", type: .normal)
        self.lastNameInput = lastNameInput
        view.addSubview(lastNameInput)
        
        let agreementTextView = UITextView()
        agreementTextView.isSelectable = true
        agreementTextView.isEditable = false
        agreementTextView.delegate = self
        agreementTextView.isScrollEnabled = false
        let agreementString = "By tapping Sign Up & Accept, you acknowledge that you have read the Privacy Policy and agree to the Term of Service"
        let attributedString = NSMutableAttributedString(string: agreementString)
        let privacyRange =  (agreementString as NSString).range(of: "Privacy Policy")
        let wholeRange = NSRange(location: 0, length: agreementString.count)
        let tosRange =  (agreementString as NSString).range(of: "Term of Service")
        attributedString.addAttribute(.link, value: "\(String.appScheme)privacy", range: privacyRange)
        attributedString.addAttribute(.link, value: "\(String.appScheme)tos", range: tosRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: privacyRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: tosRange)
        attributedString.addAttribute(.font, value: UIFont.avenirNext(bold: .medium, size: 12), range: wholeRange)
        attributedString.addAttribute(.kern, value: 0.5, range: wholeRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -3
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: wholeRange)
        agreementTextView.attributedText = attributedString
        self.agreementTextView = agreementTextView
        view.addSubview(agreementTextView)
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
        
        firstNameInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
        }
        
        lastNameInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(container)
            make.top.equalTo(firstNameInput.snp.bottom).offset(18)
        }
        
        agreementTextView.snp.makeConstraints { (make) in
            make.left.equalTo(container).offset(-4)
            make.right.equalTo(container).offset(4)
            make.top.equalTo(lastNameInput.snp.bottom)
        }
    }
    
    private func checkInputValid() {
        inputValid = !firstNameInput.isEmpty && !lastNameInput.isEmpty
        print("input valid : \(inputValid)")
    }
    
    @objc func nextButtonTapped() {
        registrationInfo.firstName = firstNameInput.text
        registrationInfo.lastName = lastNameInput.text
        let passwordController = PasswordViewController(registrationInfo: registrationInfo)
        navigationController?.pushViewController(passwordController, animated: false)
    }
}

extension NameViewController: TYInputDelegate {
    func input(_ input: TYInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowInput = string.allSatisfy { $0.isLetter }
        if !allowInput {
            input.blink()
        }
        return allowInput
    }
    
    func input(_ input: TYInput, valueChangeTo string: String?) {
        checkInputValid()
    }
}

extension NameViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let kind = URL.absoluteString.components(separatedBy: String.appScheme).last {
            let agreement: Agreement
            
            switch kind {
            case "privacy":
                agreement = .privacy
            case "tos":
                agreement = .tos
            default:
                agreement = .tos
            }
            
            let agreementController = AgreementController(agreement: agreement)
            let navController = UINavigationController(rootViewController: agreementController)
            present(navController, animated: true, completion: nil)
        }
        return false
    }
}
