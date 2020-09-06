//
//  BreedsService.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol BreedsServiceProtocol {
    func fetchBreeds(quantity: Int, page: Int, completion: @escaping ServiceCompletion)
}

final class BreedsService: BreedsServiceProtocol {
    let networkService: NetworkService = .shared

    func fetchBreeds(quantity: Int, page: Int, completion: @escaping ServiceCompletion) {
        let (request, error) = networkService.createRequest(with: .get, endpoint: "breeds?limit=\(quantity)&page=\(page)")
        guard error == nil, let breedsRequest = request else {
            completion(.failure(.malformedURL))
            return
        }
        networkService.executeDataTask(with: breedsRequest, completion: completion)
    }
}
