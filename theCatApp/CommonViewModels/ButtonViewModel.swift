//
//  ButtonViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct ButtonViewModel {
    var title: String
    var image: UIImage?
    var appearance: ButtonAppearance = .init()
}

struct ButtonAppearance {
    var titleFont: UIFont
    var titleColor: UIColor
    var backgroundColor: UIColor?
    var cornerRadius: CGFloat?

    init(titleFont: UIFont = .regular(size: 14),
         titleColor: UIColor = .primaryText,
         backgroundColor: UIColor? = nil,
         cornerRadius: CGFloat? = nil) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

extension UIButton {
    func setup(with viewModel: ButtonViewModel) {
        setTitle(viewModel.title, for: .normal)
        if let image = viewModel.image {
            setImage(image, for: .normal)
            imageView?.contentMode = .scaleAspectFit
        }
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: ButtonAppearance) {
        titleLabel?.font = appearance.titleFont
        setTitleColor(appearance.titleColor, for: .normal)
        backgroundColor = appearance.backgroundColor
        if let cornerRadius = appearance.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
    }
}
