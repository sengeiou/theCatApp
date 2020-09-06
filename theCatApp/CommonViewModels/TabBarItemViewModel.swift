//
//  TabBarItemViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct TabBarItemViewModel {
    var title: String
    var appearance: TabBarAppearance
}

struct TabBarAppearance {
    var image: UIImage
    var selectedImage: UIImage
    var titleColor: UIColor
    var selectedTitleColor: UIColor
    var font: UIFont
    var selectedFont: UIFont
    var imageColor: UIColor
}

extension UITabBarItem {
    func setup(with viewModel: TabBarItemViewModel) {
        title = viewModel.title
        setup(with: viewModel.appearance)
    }

    func setup(with appearance: TabBarAppearance) {
        let attributes: [NSAttributedString.Key: Any] = [.backgroundColor: appearance.titleColor, .font: appearance.font]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: appearance.selectedTitleColor, .font: appearance.selectedFont]

        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)

        image = appearance.image
        selectedImage = appearance.selectedImage

        UITabBar.appearance().tintColor = appearance.imageColor
    }
}
