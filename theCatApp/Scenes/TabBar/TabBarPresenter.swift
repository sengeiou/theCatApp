//
//  TabBarPresenter.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol TabBarPresenterProtocol { }

final class TabBarPresenter: MVPPresenter {
    weak var view: TabBarView?
}

extension TabBarPresenter: TabBarPresenterProtocol {
    func sceneDidLoad() {
        view?.setupView(with: createViewModel())
    }
}

private extension TabBarPresenter {
    func createViewModel() -> TabBarViewModel {
        .init(items: [.init(title: "Breeds",
                            appearance: .init(image: UIImage(named: "CatIcon") ?? UIImage(),
                                              selectedImage: UIImage(named: "SelectedCatIcon") ?? UIImage(),
                                              titleColor: .primaryText,
                                              selectedTitleColor: .primary,
                                              font: .light(size: 12),
                                              selectedFont: .bold(size: 12),
                                              imageColor: .primary)),
                      .init(title: "Vote",
                            appearance: .init(image: UIImage(named: "LoveIcon") ?? UIImage(),
                                              selectedImage: UIImage(named: "SelectedLoveIcon") ?? UIImage(),
                                              titleColor: .primaryText,
                                              selectedTitleColor: .primary,
                                              font: .light(size: 12),
                                              selectedFont: .bold(size: 12),
                                              imageColor: .primary))])
    }
}

extension MVPView where Self: TabBarView {
    func inject() -> TabBarPresenterProtocol {
        let presenter = TabBarPresenter()
        presenter.view = self
        return presenter
    }
}
