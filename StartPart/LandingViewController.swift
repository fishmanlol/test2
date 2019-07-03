//
//  LandingViewController.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class LandingViewController: UIViewController {
    weak var logInButton: UIButton!
    weak var signUpButton: UIButton!
    weak var logoImageView: UIImageView!
    weak var topArea: UILayoutGuide!
    weak var bottomArea: UILayoutGuide!
    
    override func viewDidLoad() {
        setup()
        viewsSetup()
        viewsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardService.startWork()
    }
    
    //Private functions
    private func setup() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    
    private func viewsSetup() {
        
        let topArea = UILayoutGuide()
        self.topArea = topArea
        view.addLayoutGuide(topArea)
        
        let bottomArea = UILayoutGuide()
        self.bottomArea = bottomArea
        view.addLayoutGuide(bottomArea)
        
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.avenirNext(bold: .medium, size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let logInButton = UIButton(type: .system)
        logInButton.setAttributedTitle(NSAttributedString(string: "LOG IN", attributes: attributes), for: .normal)
        logInButton.backgroundColor = UIColor(r: 247, g: 163, b: 32)
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        self.logInButton = logInButton
        view.addSubview(logInButton)
        
        let signUpButton = UIButton(type: .system)
        signUpButton.setAttributedTitle(NSAttributedString(string: "SIGN UP", attributes: attributes), for: .normal)
        signUpButton.backgroundColor = UIColor(r: 59, g: 143, b: 206)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.signUpButton = signUpButton
        view.addSubview(signUpButton)
        
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        self.logoImageView = logoImageView
        view.addSubview(logoImageView)
    }
    
    private func viewsLayout() {
        bottomArea.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
        
        topArea.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomArea.snp.top)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(topArea)
            make.width.equalTo(140)
            make.height.equalTo(logoImageView.snp.width)
        }
        
        logInButton.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bottomArea)
            make.height.equalTo(bottomArea).multipliedBy(0.5)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomArea)
            make.height.equalTo(bottomArea).multipliedBy(0.5)
        }
    }
    
    //Objc functions
    @objc func logInButtonTapped() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    @objc func signUpButtonTapped() {
        let nameController = NameViewController()
        navigationController?.pushViewController(nameController, animated: false)
    }
}
