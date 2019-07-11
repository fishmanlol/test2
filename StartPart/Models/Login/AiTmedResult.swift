//
//  AiTmedResult.swift
//  StartPart
//
//  Created by Yi Tong on 7/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

protocol ResultData {
    init?(dict: [String: Any])
}

class AiTmedResult<T: ResultData> {
    let errorCode: String
    var errorDetails: [ErrorDetail]?
    var data: T?
    var pagination: Int?
    
    init?(dict: [String: Any]) {
        guard let errorCode = dict["error_code"] as? Int else { return nil }
        self.errorCode = "\(errorCode)"
        
        if let errorDetailsDict = dict["error_detail"] as? [String: String] {
            self.errorDetails = []
            for singleErrorDetail in errorDetailsDict {
                let errorDetail = ErrorDetail(errorPair: singleErrorDetail)
                self.errorDetails?.append(errorDetail)
            }
        }
        
        if let rawDict = dict["data"] as? [String: Any], let data = T(dict: rawDict)  {
            self.data = data
        }
        
        if let pagination = dict["pagination"] as? Int {
            self.pagination = pagination
        }
    }

    struct ErrorDetail {
        var errorName: String
        var errorMessage: String
        
        init(errorPair: (String, String)) {
            let (errorName, errorMessage) = errorPair
            self.errorName = errorName
            self.errorMessage = errorMessage
        }
    }
}

//Registraion Data
class RegistrationAndLoginResultData: ResultData {
    let userId: String
    let jwtToken: String
    let tvToken: String
    
    required init?(dict: [String: Any]) {
        guard let userId = dict["user_id"] as? String, let jwtToken = dict["jwt_token"] as? String, let tvToken = dict["tv_access_token"] as? String else {
            return nil
        }
        
        self.userId = userId
        self.jwtToken = jwtToken
        self.tvToken = tvToken
    }
}

//Verification Data
class VerificationResultData: ResultData {

    required init?(dict: [String: Any]) { return nil }
}

//Reset Password Data
class ResetPasswordResultData: ResultData {
    let userId: String
    let phoneNumber: String
    
    required init?(dict: [String : Any]) {
        guard let userId = dict["user_id"] as? String, let phoneNumber = dict["phone_number"] as? String else {
            return nil
        }
        
        self.userId = userId
        self.phoneNumber = phoneNumber
    }
}
