//
//  ViewController.swift
//  StartPart
//
//  Created by Yi Tong on 6/26/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var textField: TYInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let textField = TYInput(frame: CGRect(x: 100, y: 200, width: 200, height: 60), label: "FIRST NAME")
        self.textField = textField
        view.addSubview(textField)
        textField.textField.delegate = self
        textField.textField.textColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("123")
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
}

