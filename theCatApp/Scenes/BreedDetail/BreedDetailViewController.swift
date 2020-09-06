//
//  BreedDetailViewController.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol BreedDetailView: class {
    func setupView(with viewModel: BreedDetailViewModel)
    func updateMainImage(with viewModel: ImageViewModel)
    func showAlert(title: String, message: String)
    func showImageLoader()
    func hideImageLoader()
}

class BreedDetailViewController: BaseViewController, MVPView {
    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var lifeSpanLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var temperamentLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var showWikipediaInfoButton: UIButton!

    var presenter: BreedDetailPresenterProtocol?
    lazy var imageLoaderView: UIView = {
        return mainImage.getLoadingView()
    }()

    init(breedModel: BreedModel) {
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: .main)
        self.presenter = self.inject(breedModel: breedModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func onShowWikipediaInfoButtonDidTap(_ sender: UIButton) {
        presenter?.onShowWikipediaInfoButtonDidTap()
    }
}

extension BreedDetailViewController: BreedDetailView {
    func setupView(with viewModel: BreedDetailViewModel) {
        navigationItem.setup(with: viewModel.navigationItem)
        updateMainImage(with: viewModel.mainImage)
        originLabel.setup(with: viewModel.originLabel)
        lifeSpanLabel.setup(with: viewModel.lifeSpanLabel)
        weightLabel.setup(with: viewModel.weightLabel)
        temperamentLabel.setup(with: viewModel.temperamentLabel)
        descriptionLabel.setup(with: viewModel.descriptionLabel)
        showWikipediaInfoButton.setup(with: viewModel.showWikipediaInfoButton)
    }

    func updateMainImage(with viewModel: ImageViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.mainImage.setup(with: viewModel)
        }
    }

    func showImageLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainImage.showLoadingView(self.imageLoaderView)
        }
    }

    func hideImageLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainImage.hideLoadingView(self.imageLoaderView)
        }
    }
}
