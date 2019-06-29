//
//  NameViewController.swift
//  StartPart
//
//  Created by Yi Tong on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class NameViewController: FlowBaseController {
    
    weak var firstNameInput: TYInput!
    weak var lastNameInput: TYInput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = firstNameInput.becomeFirstResponder()
    }
    
    private func viewsSetup() {
        let firstNameInput = TYInput(frame: CGRect.zero, label: "FIRST NAME", type: .normal)
        self.firstNameInput = firstNameInput
        view.addSubview(firstNameInput)
    }
    
    private func viewsLayout() {
        firstNameInput.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(60)
        }
    }
}
