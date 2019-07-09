//
//  APIService.swift
//  StartPart
//
//  Created by Yi Tong on 7/8/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    static let baseURLString = "https://testapi.aitmed.com/"
    
    //login
    static let loginWithPasswordURLString = "v2beta1/account/patient/login/"
    static let loginWithVerificationCodeURLString = "v2beta1/account/patient/login/?method=sms_verify"
    //send verification code
    static let sendVerificationCodeURLString = "v2beta1/sms/send_verification_code/"
    //registration
    static let registerURLString = "v2beta1/account/patient/"
    
    static let shared: APIService = APIService()
    
    private init() {}
    
    func login(phoneNumber: String, password: String, completion: (Bool) -> Void) {
        
    }
    
    func login(phoneNumber: String, verificationCode: String, completion: (Bool) -> Void) {
        
    }
    
    func sendVerficationCode(phoneNumber: String, completion: @escaping (Error?, AiTmedResult?) -> Void) {
        let urlString = APIService.baseURLString + APIService.sendVerificationCodeURLString
        let parameters: [String: String] = ["phone_number": phoneNumber]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("verification result: ", response.result)
            
            if let error = response.error {
                print(error)
                completion(error, nil)
                return
            }
            
            if let dict = response.value as? [String: Any], let result = AiTmedResult(dict: dict) {
                completion(nil, result)
            } else {
                completion(nil, nil)
            }
            
        }
    }
    
    func validVerificationCode(phoneNumber: String, verificationCode: String, completion: (Bool) -> Void) {
        
    }
    
    func register(phoneNumber: String, verificationCode: String, password: String, firstName: String, middleName: String?, lastName: String?, completion: @escaping (Bool, Error?) -> Void) {
        let urlString = APIService.baseURLString + APIService.registerURLString
        let parameters: [String: String] = ["phone_number": phoneNumber,
                                            "phone_verification_code": verificationCode,
                                            "password": password,
                                            "first_name": firstName,
                                            "middle_name": middleName ?? "",
                                            "last_name": lastName ?? ""]

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("register result: ", response.result)
            
            if let error = response.error {
                print(error)
                completion(false, error)
                return
            }
            
            if let dict = response.value as? [String: Any], let result = AiTmedResult(dict: dict) {
                print(result)
                if result.errorCode == "0" {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
}

