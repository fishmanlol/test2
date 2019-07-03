//
//  Notification.Name.swift
//  StartPart
//
//  Created by tongyi on 6/28/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit

extension UIResponder {
    public class var keyboardWillChangeHeightNotification: NSNotification.Name {
        return NSNotification.Name.init(rawValue: "keyboardWillChangeHeight")
    }
    
    public class var countryChangedInPhoneTextFieldNotification: NSNotification.Name {
        return NSNotification.Name.init(rawValue: "countryChangedInPhoneTextField")
    }
}
