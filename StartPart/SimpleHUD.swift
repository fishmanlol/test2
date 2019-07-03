//
//  SimpleHUD.swift
//  StartPart
//
//  Created by Yi Tong on 7/2/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

class SimpleHUD: UIView {
    private weak var indicatorView: UIActivityIndicatorView!
    private weak var label: UILabel!
    private weak var container: UILayoutGuide!
    
    init(labelString: String, indicatorStyle: UIActivityIndicatorView.Style = .gray) {
        super.init(frame: UIScreen.main.bounds)
        viewsSetup(with: labelString, style: indicatorStyle)
        viewsLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewsSetup(with labelString: String, style: UIActivityIndicatorView.Style) {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        self.indicatorView = indicatorView
        addSubview(indicatorView)
        
        let label = UILabel()
        label.text = labelString
        self.label = label
        addSubview(label)
        
        let container = UILayoutGuide()
        self.container = container
        addLayoutGuide(container)
    }
    
    private func viewsLayout() {
        indicatorView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(container)
            make.width.height.equalTo(30)
        }
        
        label.snp.makeConstraints { (make) in
            make.right.centerY.equalTo(container)
        }
        
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(indicatorView.intrinsicContentSize.width + label.intrinsicContentSize.width + 10)
            make.height.equalTo(max(indicatorView.intrinsicContentSize.height, label.intrinsicContentSize.height))
        }
    }
    
    private func setup() {
        backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
}
