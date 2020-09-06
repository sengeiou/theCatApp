//
//  BreedsFacade.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol BreedsFacadeProtocol {
    func fetchBreeds(quantity: Int, page: Int, completion: @escaping DecodableCompletion)
}

final class BreedsFacade {
    static let instance = BreedsFacade()
    private lazy var decoder: JSONDecoder = .init()
    let service: BreedsServiceProtocol

    init(service: BreedsServiceProtocol = BreedsService()) {
        self.service = service
    }
}

extension BreedsFacade: BreedsFacadeProtocol {
    func fetchBreeds(quantity: Int, page: Int, completion: @escaping DecodableCompletion) {
        service.fetchBreeds(quantity: quantity, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.decodeBreeds(from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func decodeBreeds(from data: Data, completion: DecodableCompletion) {
        do {
            let breeds = try decoder.decode([BreedModel].self, from: data)
            completion(.success(breeds))
        } catch {
            completion(.failure(.parseData))
        }
    }
}

extension MVPPresenter {
    static func inject() -> BreedsFacadeProtocol {
        BreedsFacade.instance
    }
}
