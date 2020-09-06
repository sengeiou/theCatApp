//
//  CatsService.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol CatsServiceProtocol {
    func fetchCatImage(breedId: String?, completion: @escaping ServiceCompletion)
    func fetchImageData(from urlString: String, completion: @escaping ServiceCompletion)
}

final class CatsService: CatsServiceProtocol {
    let networkService: NetworkService = .shared

    func fetchCatImage(breedId: String? = nil, completion: @escaping ServiceCompletion) {
        var additionalQueryParams = ""
        if let breedId = breedId {
            additionalQueryParams = "&breedId=\(breedId)"
        }
        let (request, error) = networkService.createRequest(with: .get, endpoint: "images/search?size=small\(additionalQueryParams)")
        guard error == nil, let breedImageRequest = request else {
            completion(.failure(.malformedURL))
            return
        }
        networkService.executeDataTask(with: breedImageRequest, completion: completion)
    }

    func fetchImageData(from urlString: String, completion: @escaping ServiceCompletion) {
        networkService.fetchImage(from: urlString, completion: completion)
    }
}
