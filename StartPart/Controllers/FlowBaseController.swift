//
//  FlowBaseController.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class FlowBaseViewController: UIViewController {
    
    private weak var backButton: UIButton!
    private weak var buttonArea: UIView!
    weak var nextButton: UIButton!
    var inputValid: Bool = false {
        didSet {
            modifyUI(valid: inputValid)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if let firstInput = view.subviews.first(where: { $0 is TYInput }) {
            let _ = firstInput.becomeFirstResponder()
        }
    }
    
    public func hideBackButton() {
        backButton.isHidden = true
    }
    
    //Private functions
    private func setup() {
        view.backgroundColor = .white
        inputValid = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightChanged), name: UIResponder.keyboardWillChangeHeightNotification, object: nil)
    }
    
    private func viewsSetup() {
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton = backButton
        view.addSubview(backButton)
        
        let buttonArea = UIView()
        self.buttonArea = buttonArea
        view.addSubview(buttonArea)
        
        let nextButton = UIButton(type: .system)
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = 20
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.kern: 1.3]
        nextButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: attributes), for: .normal)
        self.nextButton = nextButton
        buttonArea.addSubview(nextButton)
    }
    
    private func viewsLayout() {
        backButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(18)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            } else {
                make.left.equalToSuperview().offset(18)
                make.top.equalToSuperview().offset(12)
            }
            make.height.width.equalTo(26)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(40)
        }
        
        buttonArea.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-KeyboardService.keyboardHeight)
        }
    }
    
    func buttonAreaLayout(_ keyboardHeight: CGFloat) {
        buttonArea.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    
    private func modifyUI(valid: Bool) {
        if valid {
            nextButton.backgroundColor = UIColor(r: 59, g: 143, b: 206)
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = UIColor(r: 186, g: 192, b: 198)
            nextButton.isEnabled = false
        }
    }
    
    //Objc functions
    @objc func keyboardHeightChanged(notification: Notification) {
        if let height = notification.userInfo?["keyboardHeight"] as? CGFloat {

            buttonAreaLayout(height)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        print(#function)
    }
}
