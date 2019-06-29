//
//  Country.swift
//  StartPart
//
//  Created by Yi Tong on 6/27/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct Country {
    let id: String
    let name: String
    let code: String
    
    var displayFormat: String {
        return "\(id) +\(code)"
    }
    
    static var defaultCountry: Country {
        return Country(id: "US", name: "United States", code: "1")
    }
}

extension Country: Comparable {
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.name < rhs.name
    }
}
