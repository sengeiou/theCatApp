//
//  MVP.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol MVPPresenter: class, SceneObserver {
    associatedtype View

    var view: View? { get }
}

protocol MVPView: SceneController {
    associatedtype Presenter

    var presenter: Presenter { get }
}

extension MVPView {
    var observer: SceneObserver? {
        return presenter as? SceneObserver
    }
}
