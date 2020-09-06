//
//  NavigationItemViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct NavigationItemViewModel {
    var title: String
    var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode

    init(title: String,
         largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .always) {
        self.title = title
        self.largeTitleDisplayMode = largeTitleDisplayMode
    }
}

extension UINavigationItem {
    func setup(with viewModel: NavigationItemViewModel) {
        title = viewModel.title
        largeTitleDisplayMode = viewModel.largeTitleDisplayMode
    }
}
