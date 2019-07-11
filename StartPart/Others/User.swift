//
//  User.swift
//  StartPart
//
//  Created by Yi Tong on 7/10/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//


class User {
    
    static let shard = User()
    private init() {}
    
    var auth: Auth?
    var profile: Profile?
    
    struct Auth {
        let jwt: String
        let userId: String
        let tvt: String
    }
    
    struct Profile {
        var firstName: String?
        var lastName: String?
        var middleName: String?
        var phoneNumber: String?
    }
}
