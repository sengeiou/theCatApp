//
//  BaseViewController.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol SceneController {
    var observer: SceneObserver? { get }
}

class BaseViewController: UIViewController {
    private var sceneObserver: SceneObserver? {
        return (self as? SceneController)?.observer
    }

    override func viewDidLoad() {
        let nibName = String(describing: type(of: self))
        self.view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        sceneObserver?.sceneDidLoad()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        sceneObserver?.sceneWillAppear()
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        sceneObserver?.sceneDidAppear()
        super.viewDidAppear(animated)
    }
}

extension BaseViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK".localized(), style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
    }
}
