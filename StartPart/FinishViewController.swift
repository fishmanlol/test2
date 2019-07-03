//
//  FinishViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/2/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class FinishViewController: FlowBaseViewController {
    
    weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsSetup()
        viewsLayout()
        setup()
    }
    
    private func viewsSetup() {
        let imageView = UIImageView(image: UIImage(named: "finish_page"))
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        view.addSubview(imageView)
    }
    
    private func viewsLayout() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        buttonAreaLayout(30)
    }
    
    private func setup() {
        hideBackButton()
        inputValid = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
