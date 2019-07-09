//
//  VerificationResult.swift
//  StartPart
//
//  Created by Yi Tong on 7/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

//import Foundation
//
//class VerificationResult: AiTmedResult {
//    
//    var data: VerificationData?
//    
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//        
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.errorDetails = try container.decode([ErrorDetail].self, forKey: .errorDetails)
//        self.data = try container.decode(VerificationData.self, forKey: .data)
//    }
//    
//    struct VerificationData: Decodable {
//        let phoneNumber: String
//        let verification_code: String
//    }
//}
