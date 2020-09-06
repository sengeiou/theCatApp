//
//  UIViewExtension.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol LoadingScreenProtocol {
    func getLoadingView() -> UIView
    func showLoadingView(_ view: UIView)
    func hideLoadingView(_ view: UIView)
}

extension UIView: LoadingScreenProtocol {
    func getLoadingView() -> UIView {
        let loaderView = UIView(frame: bounds)
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let spinner = UIActivityIndicatorView()
        spinner.setup(with: .init(center: loaderView.center))
        loaderView.addSubview(spinner)
        spinner.startAnimating()
        return loaderView
    }

    func showLoadingView(_ view: UIView) {
        addSubview(view)
    }

    func hideLoadingView(_ view: UIView) {
        view.removeFromSuperview()
    }
}
