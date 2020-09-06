//
//  VoteForImageViewController.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol VoteForImageView: class {
    func setupView(with viewModel: VoteForImageViewModel)
    func updateImageView(with viewModel: ImageViewModel)
    func showAlert(title: String, message: String)
    func showImageLoader()
    func hideImageLoader()
}

final class VoteForImageViewController: BaseViewController, MVPView {
    @IBOutlet private weak var imageContainer: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dislikeButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!

    lazy var presenter: VoteForImagePresenterProtocol = inject()
    lazy var imageLoaderView: UIView = {
        return imageContainer.getLoadingView()
    }()

    @IBAction private func onDislikeButtonTap(_ sender: UIButton) {
        presenter.onDislikeButtonTap()
    }

    @IBAction private func onLikeButtonTap(_ sender: UIButton) {
        presenter.onLikeButtonTap()
    }
}

extension VoteForImageViewController: VoteForImageView {
    func setupView(with viewModel: VoteForImageViewModel) {
        imageContainer.setup(with: viewModel.imageContainer)
        updateImageView(with: viewModel.imageView)
        dislikeButton.setup(with: viewModel.dislikeButton)
        likeButton.setup(with: viewModel.likeButton)
    }

    func updateImageView(with viewModel: ImageViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.setup(with: viewModel)
        }
    }

    func showImageLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageContainer.showLoadingView(self.imageLoaderView)
        }
    }

    func hideImageLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageContainer.hideLoadingView(self.imageLoaderView)
        }
    }
}
