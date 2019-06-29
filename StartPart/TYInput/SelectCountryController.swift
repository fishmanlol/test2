//
//  SelectCountryController.swift
//  StartPart
//
//  Created by Yi Tong on 6/27/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import UIKit
import SnapKit

class SelectCountryController: UIViewController {
    
    weak var tableView: UITableView!
    
    let vm = SelectCountryViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        title = vm.title()
        view.backgroundColor = .white
        vm.delegate = self
        
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SelectCountryController: SelectCountryViewModelDelegate {
    func reload() {
        tableView.reloadData()
    }
}

extension SelectCountryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        vm.configure(cell, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.countryCount()
    }
    
}

extension SelectCountryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewController = self.presentingViewController as? ViewController {
            viewController.selectedCountry = self.vm.country(at: indexPath.row) ?? Country.defaultCountry
        }
        
        dismiss(animated: true)
    }
}
