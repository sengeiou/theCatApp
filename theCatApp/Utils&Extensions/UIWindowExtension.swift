//
//  UIWindowExtension.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

extension UIWindow {
    func setRootViewController() {
        let tabBarController = TabBarController(viewControllers: [createFirstController(), createSecondController()])
        rootViewController = tabBarController
    }

    private func createFirstController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [BreedsViewController()]
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .white

        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.bold(size: 18)]
        let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.bold(size: 34)]
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = titleTextAttributes
            navBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            navBarAppearance.backgroundColor = .primary
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController.navigationBar.barTintColor = .primary
            navigationController.navigationBar.titleTextAttributes = titleTextAttributes
            navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
        }
        return navigationController
    }

    private func createSecondController() -> VoteForImageViewController {
        return VoteForImageViewController()
    }
}
