//
//  ViewController.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedCountry: Country = Country.defaultCountry {
        didSet {
            if let phoneTextField = textField?.textField as? TYPhoneTextField {
                phoneTextField.selectedCountry = selectedCountry
            }
        }
    }
    weak var textField: TYInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let textField = TYInput(frame: CGRect(x: 100, y: 200, width: 200, height: 60), label: "FIRST NAME", type: .password)
        self.textField = textField
        view.addSubview(textField)
        textField.textField!.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
//        let selectCountryController = SelectCountryController()
//        let navController = UINavigationController(rootViewController: selectCountryController)
//        present(navController, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
}

