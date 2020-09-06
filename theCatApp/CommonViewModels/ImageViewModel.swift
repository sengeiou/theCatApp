//
//  ImageViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct ImageViewModel {
    var image: UIImage
    var appearance: ImageAppearance = .init()
}

struct ImageAppearance {
    var contentMode: UIView.ContentMode
    var backgroundColor: UIColor
    var cornerRadius: CGFloat?

    init(contentMode: UIView.ContentMode = .scaleAspectFit,
         backgroundColor: UIColor = .clear,
         cornerRadius: CGFloat? = nil) {
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

extension UIImageView {
    func setup(with viewModel: ImageViewModel) {
        image = viewModel.image
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: ImageAppearance) {
        contentMode = appearance.contentMode
        backgroundColor = appearance.backgroundColor
        if let cornerRadius = appearance.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
    }
}
