//
//  CatsFacade.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol CatsFacadeProtocol {
    func fetchCatImage(breedId: String?, completion: @escaping DecodableCompletion)
    func fetchImageData(from urlString: String, completion: @escaping ServiceCompletion)
}

final class CatsFacade {
    static let instance = CatsFacade()
    private lazy var decoder: JSONDecoder = .init()
    let service: CatsServiceProtocol

    init(service: CatsServiceProtocol = CatsService()) {
        self.service = service
    }
}

extension CatsFacade: CatsFacadeProtocol {
    func fetchCatImage(breedId: String? = nil, completion: @escaping DecodableCompletion) {
        service.fetchCatImage(breedId: breedId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.decodeCatImage(from: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchImageData(from urlString: String, completion: @escaping ServiceCompletion) {
        service.fetchImageData(from: urlString, completion: completion)
    }

    private func decodeCatImage(from data: Data, completion: DecodableCompletion) {
        do {
            let catImageModel = try decoder.decode(CatImageModel.self, from: data)
            completion(.success(catImageModel))
        } catch {
            completion(.failure(.parseData))
        }
    }
}

extension MVPPresenter {
    static func inject() -> CatsFacadeProtocol {
        CatsFacade.instance
    }
}
