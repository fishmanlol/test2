//
//  agreementController.swift
//  StartPart
//
//  Created by tongyi on 6/30/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class AgreementController: UIViewController {
    
    var agreement: Agreement
    
    init(agreement: Agreement) {
        self.agreement = agreement
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        agreement = .privacy
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        title = agreement.displayOnTitle
        view.backgroundColor = .white
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_back"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

enum Agreement {
    case privacy, tos
    
    var displayOnTitle: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .tos:
            return "Term of Use"
        }
    }
}
