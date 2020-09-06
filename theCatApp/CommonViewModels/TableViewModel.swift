//
//  TableViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct TableViewModel {
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?
    var appearance: TableAppearance
}

struct TableAppearance {
    var backgroundColor: UIColor?
}

extension UITableView {
    func setup(with viewModel: TableViewModel) {
        delegate = viewModel.delegate
        dataSource = viewModel.dataSource
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: TableAppearance) {
        backgroundColor = appearance.backgroundColor
    }
}
