//
//  TYNormalTextField.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class TYPhoneTextField: TYNormalTextField {
    
    weak var areaButton: UIButton!
    weak var separateLine: UIView!
    weak var leftContainer: UIView!
    
    let margin: CGFloat = 14
    var separateLineWidth: CGFloat = 1.2
    
    var selectedCountry = Country.defaultCountry {
        didSet {
            if oldValue != selectedCountry {
                updateAreaButtonTitle(selectedCountry.displayFormat)
                updateLeftContainerSize(selectedCountry.displayFormat)
                
                NotificationCenter.default.post(name: UIResponder.countryChangedInPhoneTextFieldNotification, object: nil, userInfo: ["country": selectedCountry])
            }
        }
    }
    
    let leftViewAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: TYInput.defaultTextFont, NSAttributedString.Key.foregroundColor: UIColor(r: 79, g: 170, b: 248)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        keyboardType = .numberPad
        textContentType = nil
        
        //container view
        let view = UIView()
        self.leftContainer = view
        
        //area button
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(areaCodeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.areaButton = button
        leftContainer.addSubview(button)
        
        //separate line
        let separateLine = UIView()
        separateLine.backgroundColor = TYInput.defaultBottomLineColor
        separateLine.translatesAutoresizingMaskIntoConstraints = false
        self.separateLine = separateLine
        leftContainer.addSubview(separateLine)
        
        selectedCountry = Country.defaultCountry
        
        leftView = leftContainer
        leftViewMode = .always
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        areaButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        separateLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.width.equalTo(separateLineWidth)
            make.left.equalTo(areaButton.snp.right).offset(5)
        }
    }
    
    private func updateLeftContainerSize(_ title: String) {
        let attributedAreaTitle = NSAttributedString(string: title, attributes: leftViewAttributes)
        let titleSize = attributedAreaTitle.size()
        leftContainer.frame.size = CGSize(width: titleSize.width + margin, height: titleSize.height)
        //little trick after changing left view frame. Because only change leftview frame will let layout weird(when leftview width increase, it will cover part of editing area), we do this to let system help us coordinate the layout
        becomeFirstResponder()
        resignFirstResponder()
    }
    
    private func updateAreaButtonTitle(_ title: String) {
        areaButton.setAttributedTitle(NSAttributedString(string: title, attributes: leftViewAttributes), for: .normal)
    }
    
    private func getCurrentViewController() -> UIViewController? {
        if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return nav.visibleViewController
        }
        return nil
    }
    
    @objc func areaCodeButtonTapped() {
        let selectCountryController = SelectCountryController()
        selectCountryController.delegate = self
        let navController = UINavigationController(rootViewController: selectCountryController)
        getCurrentViewController()?.present(navController, animated: true, completion: nil)
    }
}

extension TYPhoneTextField: SelectCountryControllerDelegate {
    func select(selectCountryController: SelectCountryController, country: Country) {
        selectedCountry = country
    }
}
