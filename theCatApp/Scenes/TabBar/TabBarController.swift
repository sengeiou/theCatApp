//
//  TabBarController.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol TabBarView: class {
    func setupView(with viewModel: TabBarViewModel)
}

final class TabBarController: UITabBarController, MVPView {
    private var sceneObserver: SceneObserver? {
        return (self as SceneController).observer
    }
    lazy var presenter: TabBarPresenterProtocol = inject()
    private var controllers: [UIViewController]

    init(viewControllers: [UIViewController]) {
        self.controllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        sceneObserver?.sceneDidLoad()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        sceneObserver?.sceneWillAppear()
        super.viewWillAppear(animated)
    }
}

extension TabBarController: TabBarView {
    func setupView(with viewModel: TabBarViewModel) {
        for (index, item) in viewModel.items.enumerated() {
            controllers[index].tabBarItem.setup(with: item)
        }
        viewControllers = controllers
    }
}
