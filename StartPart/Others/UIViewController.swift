//
//  UIViewController.swift
//  StartPart
//
//  Created by Yi Tong on 7/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(title: String?, msg: String, hasCancel: Bool, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (_) in
            action()
        }
        
        alert.addAction(OKAction)
        
        if hasCancel {
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(CancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func displayHUD(title: String = "One Moment...") {
        let HUD = SimpleHUD(labelString: title)
        view.addSubview(HUD)
    }
    
    func removeHUD() {
        for view in view.subviews {
            if view is SimpleHUD {
                view.removeFromSuperview()
            }
        }
    }
}
