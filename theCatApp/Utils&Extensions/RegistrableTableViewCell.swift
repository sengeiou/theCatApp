//
//  RegistrableTableViewCell.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol RegistrableTableViewCell {
    static var identifier: String { get }
}

extension RegistrableTableViewCell {
    static var identifier: String {
        String(describing: self)
    }

    static private var nib: UINib {
        UINib(nibName: identifier, bundle: .main)
    }
}

extension RegistrableTableViewCell where Self: UITableViewCell {
    static func register(in tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}
