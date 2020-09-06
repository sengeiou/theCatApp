//
//  UITableViewExtension.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

extension UITableView {
    private var spinnerFooter: UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.setup(with: .init(center: footerView.center))
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

    func showMoreItemsLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.tableFooterView = self?.spinnerFooter
        }
    }

    func hideMoreItemsLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.tableFooterView = nil
        }
    }
}
