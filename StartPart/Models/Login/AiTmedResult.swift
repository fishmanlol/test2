//
//  AiTmedResult.swift
//  StartPart
//
//  Created by Yi Tong on 7/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

struct AiTmedResult: Decodable {
    let errorCode: String
    var errorDetails: [ErrorDetail]?
    var data: ResultData?
    var pagination: Int?
    
    init?(dict: [String: Any]) {
        print(dict)
        guard let errorCode = dict["error_code"] as? Int else { return nil }
        self.errorCode = "\(errorCode)"
        
        if let errorDetailsDict = dict["error_detail"] as? [String: String] {
            self.errorDetails = []
            for singleErrorDetail in errorDetailsDict {
                let errorDetail = ErrorDetail(errorPair: singleErrorDetail)
                self.errorDetails?.append(errorDetail)
            }
        }
        
        if let data = dict["data"] as? ResultData {
            self.data = data
        }
        
        if let pagination = dict["pagination"] as? Int {
            self.pagination = pagination
        }
        
    }
    
//    enum CodingKeys: String, CodingKey {
//        case errorCode = "error_code"
//        case errorDetails = "error_detail"
//        case pagination = "pagination"
//        case data = "data"
//    }
//
    struct ErrorDetail: Decodable {
        var errorName: String
        var errorMessage: String
        
        init(errorPair: (String, String)) {
            let (errorName, errorMessage) = errorPair
            self.errorName = errorName
            self.errorMessage = errorMessage
        }
    }
    
    class ResultData: Decodable {}
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.errorCode = try container.decode(String.self, forKey: .errorCode)
//        self.pagination = try container.decode(Int.self, forKey: .pagination)
//    }
    
//    struct ErrorDetail: Decodable {
//        var phoneNumberError: String?
//        var phoneVerificationCodeError: String?
//        var passwordError: String?
//        var messageError: String?
//        var firstNameError: String?
//        var lastNameError: String?
//
//        enum CodingKeys: String, CodingKey {
//            case phoneNumberError = "phone_number"
//            case phoneVerificationCodeError = "phone_verification_code"
//            case passwordError = "password"
//            case messageError = "message"
//            case firstNameError = "first_name"
//            case lastNameError = "last_name"
//        }
//    }
    
    

//Registraion Data
    class RegistrationResultData: ResultData {
        let userId: String
        let jwtToken: String
        let tvToken: String

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case jwtToken = "jwt_token"
            case tvToken = "tv_access_token"
        }

        init?(userId: String?, jwtToken: String?, tvToken: String?) {
            guard let userId = userId, let jwtToken = jwtToken, let tvToken = tvToken else {
                return nil
            }
            self.userId = userId
            self.jwtToken = jwtToken
            self.tvToken = tvToken

            super.init()
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.userId = try container.decode(String.self, forKey: .userId)
            self.jwtToken = try container.decode(String.self, forKey: .jwtToken)
            self.tvToken = try container.decode(String.self, forKey: .tvToken)

            super.init()
        }
    }
    
//Verification Data
    class VerificationResultData: ResultData {
        let phoneNumber: String
        let verificationCode: String
        
        enum CodingKeys: String, CodingKey {
            case phoneNumber = "phone_number"
            case verificationCode = "verification_code"
        }
        
        init?(phoneNumber: String?, verificationCode: String?) {
            guard let phoneNumber = phoneNumber, let verificationCode = verificationCode else {
                return nil
            }
            self.phoneNumber = phoneNumber
            self.verificationCode = verificationCode
            
            super.init()
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
            self.verificationCode = try container.decode(String.self, forKey: .verificationCode)
            
            super.init()
        }
    }
}

