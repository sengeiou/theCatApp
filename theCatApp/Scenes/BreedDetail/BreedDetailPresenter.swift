//
//  BreedDetailPresenter.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol BreedDetailPresenterProtocol {
    func onShowWikipediaInfoButtonDidTap()
}

final class BreedDetailPresenter: MVPPresenter {
    weak var view: BreedDetailView?
    private let facade: CatsFacadeProtocol
    private var breedModel: BreedModel

    enum BreedDetailSection: String {
        case origin = "Origin"
        case lifeSpan = "Life Span"
        case weight = "Weight"
        case temperament = "Temperament"
        case description = "Description"
    }

    init(facade: CatsFacadeProtocol = inject(),
         breedModel: BreedModel) {
        self.facade = facade
        self.breedModel = breedModel
    }

    private func createAttributedLabelViewModel(for section: BreedDetailSection, information: String) -> LabelViewModel {
        .init(text: "",
              attributedText: .init(string: "\(section.rawValue): \(information)",
                attributedTexts: [.init(text: "\(section.rawValue):",
                    attributes: [.foregroundColor: UIColor.primary])]),
              appearance: .init(font: .regular(size: 14)))
    }
}

extension BreedDetailPresenter: BreedDetailPresenterProtocol {
    func sceneDidLoad() {
        view?.setupView(with: createViewModel())
        getMainImage()
    }

    func sceneWillAppear() {
        guard breedModel.breedImage == nil else { return }
        view?.showImageLoader()
    }

    func onShowWikipediaInfoButtonDidTap() {
        guard let url = URL(string: breedModel.wikipediaUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

private extension BreedDetailPresenter {
    func createViewModel() -> BreedDetailViewModel {
        .init(navigationItem: .init(title: breedModel.name),
              mainImage: createMainImageViewModel(image: UIImage(),
                                                  backgroundColor: .tertiary),
              originLabel: createAttributedLabelViewModel(for: .origin, information: breedModel.origin),
              lifeSpanLabel: createAttributedLabelViewModel(for: .lifeSpan, information: breedModel.lifeSpan),
              weightLabel: createAttributedLabelViewModel(for: .weight, information: breedModel.weight.metric),
              temperamentLabel: createAttributedLabelViewModel(for: .temperament, information: breedModel.temperament),
              descriptionLabel: createAttributedLabelViewModel(for: .description, information: breedModel.description),
              showWikipediaInfoButton: .init(title: "Show Wikipedia Info",
                                             appearance: .init(titleFont: .bold(size: 18),
                                                               titleColor: .white,
                                                               backgroundColor: .secondary,
                                                               cornerRadius: 5)))
    }

    func createMainImageViewModel(image: UIImage, backgroundColor: UIColor? = nil) -> ImageViewModel {
        .init(image: image,
              appearance: .init(contentMode: .scaleAspectFill,
                backgroundColor: backgroundColor ?? .clear))
    }

    func getMainImage() {
        facade.fetchCatImage(breedId: breedModel.id) { [weak self] result in
            switch result {
            case .success(let catImage):
                guard let catImageModel = catImage as? CatImageModel else { return }
                self?.getImageData(for: catImageModel)
            case .failure(let error):
                self?.view?.hideImageLoader()
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
        facade.fetchImageData(from: catImage.url) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideImageLoader()
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                let catImageModel = CatImageModel(id: catImage.id, url: catImage.url, image: image, width: catImage.width, height: catImage.height)
                self.breedModel.breedImage = catImageModel
                self.view?.updateMainImage(with: self.createMainImageViewModel(image: image ?? UIImage()))
            case .failure(let error):
                self.handleFetchCatImageError(error)
            }
        }
    }
}

extension MVPView where Self: BreedDetailView {
    func inject(breedModel: BreedModel) -> BreedDetailPresenterProtocol {
        let presenter = BreedDetailPresenter(breedModel: breedModel)
        presenter.view = self
        return presenter
    }
}
