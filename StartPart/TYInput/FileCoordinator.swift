//
//  FileCoordinator.swift
//  StartPart
//
//  Created by Yi Tong on 6/27/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation

class FileCoordinator {
    
    static let shared: FileCoordinator = FileCoordinator()
    
    let fileManager = FileManager.default
    
    private init() {}
    
    func getCountries() -> [(String, String)] {
        
        guard let path = Bundle.main.path(forResource: "countries", ofType: nil) else {
            return []
        }
        
        var countryPair: [(String, String)] = []
        
        if let contents = try? String(contentsOfFile: path, encoding: .utf8) {
            let countries = contents.components(separatedBy: .newlines)
            
            for country in countries {
                let countryItem = country.components(separatedBy: "----")
                if countryItem.count == 2 {
                    countryPair.append((countryItem[0], countryItem[1]))
                }
            }
        }
        
        return countryPair
    }
}
