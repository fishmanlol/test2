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
}

extension Country: Comparable {
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.name < rhs.name
    }
}
