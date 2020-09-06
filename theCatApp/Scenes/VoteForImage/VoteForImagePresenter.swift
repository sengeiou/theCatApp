//
//  VoteForImagePresenter.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol VoteForImagePresenterProtocol {
    func onDislikeButtonTap()
    func onLikeButtonTap()
}

final class VoteForImagePresenter: MVPPresenter {
    weak var view: VoteForImageView?
    private var currentCatImageModel: CatImageModel?
    private var nextCatImageModel: CatImageModel?
    private let facade: VotesFacadeProtocol
    private let catsFacade: CatsFacadeProtocol

    init(facade: VotesFacadeProtocol = inject(),
         catsFacade: CatsFacadeProtocol = inject()) {
        self.facade = facade
        self.catsFacade = catsFacade
        getNextCatImage()
    }
}

extension VoteForImagePresenter: VoteForImagePresenterProtocol {
    func sceneDidLoad() {
        view?.setupView(with: createViewModel())
    }

    func sceneDidAppear() {
        guard currentCatImageModel == nil else { return }
        view?.showImageLoader()
    }

    func onDislikeButtonTap() {
        sendImageVote(like: false)
    }

    func onLikeButtonTap() {
        sendImageVote(like: true)
    }
}

private extension VoteForImagePresenter {
    func createViewModel() -> VoteForImageViewModel {
        .init(imageContainer: .init(appearance: .init(cornerRadius: 10,
                                                      shadow: .init())),
              imageView: createCatImageViewModel(image: UIImage()),
              dislikeButton: .init(title: "",
                                   image: UIImage(named: "DislikeCat")),
              likeButton: .init(title: "",
                                image: UIImage(named: "LikeCat")))
    }

    func createCatImageViewModel(image: UIImage, backgroundColor: UIColor? = nil) -> ImageViewModel {
        .init(image: image,
              appearance: .init(contentMode: .scaleAspectFill,
                                backgroundColor: backgroundColor ?? .tertiary,
                                cornerRadius: 10))
    }

    func getNextCatImage() {
        catsFacade.fetchCatImage(breedId: nil) { [weak self] result in
            switch result {
            case .success(let catImage):
                guard let catImageModel = catImage as? CatImageModel else { return }
                self?.getImageData(for: catImageModel)
            case .failure(let error):
                self?.handleFetchCatImageError(error)
            }
        }
    }

    private func handleFetchCatImageError(_ error: ServiceError) {
        let title = "ERROR".localized()
        let message: String
        switch error {
        case .noInternetConnection:
            message = "NO_INTERNET_CONNECTION".localized()
        case .timeOut:
            message = "TIME_OUT_ERROR".localized()
        default:
            message = "GET_CAT_IMAGE_ERROR".localized()
        }
        view?.showAlert(title: title, message: message)
    }

    func getImageData(for catImage: CatImageModel) {
        catsFacade.fetchImageData(from: catImage.url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                let catImageModel = CatImageModel(id: catImage.id, url: catImage.url, image: image, width: catImage.width, height: catImage.height)
                if self.currentCatImageModel == nil {
                    self.currentCatImageModel = catImageModel
                    self.showCurrentCatImage()
                } else {
                    self.nextCatImageModel = catImageModel
                }
                if self.nextCatImageModel == nil {
                    self.getNextCatImage()
                }
            case .failure:
                self.getImageData(for: catImage)
            }
        }
    }

    func sendImageVote(like: Bool) {
        guard let catImageModel = currentCatImageModel else { return }
        facade.sendVote(imageId: catImageModel.id, like: like) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let votedCatModel = VotedCatModel(date: Date(), imageUrl: catImageModel.url, name: catImageModel.id, vote: like ? .like : .dislike)
                self.facade.saveVoteToStorage(votedCatModel: votedCatModel)
                self.onImageVoteSent()
            case .failure(let error):
                self.handleSendImageVoteError(error)
            }
        }
    }

    private func handleSendImageVoteError(_ error: ServiceError) {
        let title = "ERROR".localized()
        let message: String
        switch error {
        case .noInternetConnection:
            message = "NO_INTERNET_CONNECTION".localized()
        case .timeOut:
            message = "TIME_OUT_ERROR".localized()
        default:
            message = "SEND_VOTE_ERROR".localized()
        }
        view?.showAlert(title: title, message: message)
    }

    func onImageVoteSent() {
        currentCatImageModel = nextCatImageModel
        nextCatImageModel = nil
        showCurrentCatImage()
        getNextCatImage()
    }

    func showCurrentCatImage() {
        guard let catImage = currentCatImageModel?.image else { return }
        view?.updateImageView(with: createCatImageViewModel(image: catImage))
        view?.hideImageLoader()
    }
}

extension MVPView where Self: VoteForImageView {
    func inject() -> VoteForImagePresenterProtocol {
        let presenter = VoteForImagePresenter()
        presenter.view = self
        return presenter
    }
}
