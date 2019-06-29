//
//  FlowBaseController.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class FlowBaseController: UIViewController {
    
    private weak var backButton: UIButton!
    private weak var buttonArea: UIView!
    weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewsSetup()
        viewsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Private functions
    private func setup() {
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightChanged), name: Notification.Name.init(rawValue: "123"), object: KeyboardService.shared)
    }
    
    private func viewsSetup() {
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton = backButton
        view.addSubview(backButton)
        
        let buttonArea = UIView()
        buttonArea.layer.zPosition = 10
        buttonArea.backgroundColor = .gray
        self.buttonArea = buttonArea
        view.addSubview(buttonArea)
        
        let nextButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.kern: 1.3]
        nextButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: attributes), for: .normal)
        self.nextButton = nextButton
        buttonArea.addSubview(nextButton)
    }
    
    private func viewsLayout() {
        backButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            make.height.width.equalTo(32)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        buttonArea.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
        buttonAreaLayout(KeyboardService.keyboardHeight)
    }
    
    private func buttonAreaLayout(_ keyboardHeight: CGFloat) {
        buttonArea.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }
    
    //Objc functions
//    @objc func keyboardWillChangeFrame(notification: Notification) {
//        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let frame = value.cgRectValue
//            let referenceY: CGFloat = UIScreen.main.bounds.height - 0.5 * frame.height
//
//            if frame.minY < referenceY { //keyboard on screen, so we need handle
//                buttonAreaLayout(frame.height)
//                view.layoutIfNeeded()
//            }
//        }
//    }
    
    @objc func keyboardHeightChanged(notification: Notification) {
        if let height = notification.userInfo?["keyboardHeight"] as? CGFloat {

            buttonAreaLayout(height)
            view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        print(#function)
    }
}
