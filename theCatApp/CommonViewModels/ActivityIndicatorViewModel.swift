//
//  ActivityIndicatorViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct ActivityIndicatorViewModel {
    var center: CGPoint
    var appearance: ActivityIndicatorAppearance = .init()
}

struct ActivityIndicatorAppearance {
    var style: UIActivityIndicatorView.Style = .whiteLarge
    var color: UIColor = .secondary
}

extension UIActivityIndicatorView {
    func setup(with viewModel: ActivityIndicatorViewModel) {
        center = viewModel.center
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: ActivityIndicatorAppearance) {
        style = appearance.style
        color = appearance.color
    }
}
