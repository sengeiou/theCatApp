//
//  ViewViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct ViewShadow {
    var color: UIColor = .tertiaryText
    var opacity: Float = 1
    var offset: CGSize = .zero
    var radius: CGFloat = 10
}

struct ViewViewModel {
    var appearance: ViewAppearance
}

struct ViewAppearance {
    var backgroundColor: UIColor
    var cornerRadius: CGFloat?
    var shadow: ViewShadow?

    init(backgroundColor: UIColor = .clear,
         cornerRadius: CGFloat? = nil,
         shadow: ViewShadow? = nil) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
}

extension UIView {
    func setup(with viewModel: ViewViewModel) {
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: ViewAppearance) {
        backgroundColor = appearance.backgroundColor
        if let cornerRadius = appearance.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        if let shadow = appearance.shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowOpacity = shadow.opacity
            layer.shadowOffset = shadow.offset
            layer.shadowRadius = shadow.radius
            layer.masksToBounds = false
        }
    }
}
