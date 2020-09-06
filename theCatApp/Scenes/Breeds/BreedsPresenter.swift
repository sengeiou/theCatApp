//
//  BreedsPresenter.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol BreedsPresenterProtocol {
    func onLastItemShowed(completion: @escaping (() -> Void))
    func onSelectCell(at index: Int)
}

final class BreedsPresenter: MVPPresenter {
    weak var view: BreedsView?
    private let facade: BreedsFacadeProtocol
    private var page: Int = 0
    private var breedsArray: [BreedModel] = [] {
        didSet {
            view?.setBreedsArray(breeds: createBreedCellViewModelsArray(from: breedsArray))
        }
    }

    init(facade: BreedsFacadeProtocol = inject()) {
        self.facade = facade
    }
}

extension BreedsPresenter: BreedsPresenterProtocol {
    func sceneDidLoad() {
        view?.setupView(with: createViewModel())
    }

    func sceneWillAppear() {
        guard breedsArray.isEmpty else { return }
        view?.showLoader()
        getBreeds { [weak self] in
            self?.view?.hideLoader()
        }
    }

    func onLastItemShowed(completion: @escaping (() -> Void)) {
        page += 1
        getBreeds(completion: completion)
    }

    func onSelectCell(at index: Int) {
        view?.goToDetail(with: breedsArray[index])
    }
}

private extension BreedsPresenter {
    func createViewModel() -> BreedsViewModel {
        .init(navigationItem: .init(title: "Breeds"),
              breedsTable: .init(
                delegate: view as? UITableViewDelegate,
                dataSource: view as? UITableViewDataSource,
                appearance: .init()))
    }

    func getBreeds(completion: (() -> Void)? = nil) {
        facade.fetchBreeds(quantity: 10, page: page) { [weak self] result in
            switch result {
            case .success(let breeds):
                guard let newBreeds = breeds as? [BreedModel] else {
                    completion?()
                    return
                }
                self?.breedsArray.append(contentsOf: newBreeds)
            case .failure(let error):
                self?.handleGetBreedsError(error)
            }
            completion?()
        }
    }

    private func handleGetBreedsError(_ error: ServiceError) {
        let title = "ERROR".localized()
        let message: String
        switch error {
        case .noInternetConnection:
            message = "NO_INTERNET_CONNECTION".localized()
        case .timeOut:
            message = "TIME_OUT_ERROR".localized()
        default:
            message = "GET_BREEDS_ERROR".localized()
        }
        view?.showAlert(title: title, message: message)
    }

    func createBreedCellViewModelsArray(from breeds: [BreedModel]) -> [BreedCellViewModel] {
        breeds.map {
            BreedCellViewModel(nameLabel: .init(text: $0.name,
                                                appearance: .init(font: .bold(size: 20))),
                               temperamentLabel: .init(text: $0.temperament,
                                                       appearance: .init(font: .light(size: 14),
                                                                         textColor: .secondaryText)))
        }
    }
}

extension MVPView where Self: BreedsView {
    func inject() -> BreedsPresenterProtocol {
        let presenter = BreedsPresenter()
        presenter.view = self
        return presenter
    }
}
