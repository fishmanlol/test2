//
//  SelectCountryViewModel.swift
//  StartPart
//
//  Created by Yi Tong on 6/27/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import PhoneNumberKit

protocol SelectCountryViewModelDelegate: class {
    func reload()
}

class SelectCountryViewModel {
    var countries: [Country] = []
    var phoneNumberKit: PhoneNumberKit?
    weak var delegate: SelectCountryViewModelDelegate?
    
    init() {
        DispatchQueue.main.async {
            self.phoneNumberKit = PhoneNumberKit()
            self.fillCountries()
            self.delegate?.reload()
        }
    }
    
    func title() -> String {
        return "Select Country"
    }
    
    func countryCount() -> Int {
        return countries.count
    }
    
    func country(at index: Int) -> Country? {
        guard index > -1 && index < countries.count else { return nil }
        return countries[index]
    }
    
    func configure(_ cell: UITableViewCell, at index: Int) {
        let country = countries[index]
        cell.textLabel?.text = "\(country.name) (+\(country.code))"
    }
    
    private func fillCountries() {
        let countryItems = FileCoordinator.shared.getCountries()
        
        for (countryName, countryId) in countryItems {
            if let code = phoneNumberKit?.countryCode(for: countryId) {
                let country = Country(id: countryId, name: countryName, code: String(code))
                countries.append(country)
            }
        }
    }
}
