//
//  VotesService.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

struct SendVoteServiceBody: Encodable {
    var imageId: String
    var value: Int

    private enum CodingKeys: String, CodingKey {
        case imageId = "image_id"
        case value
    }
}

protocol VotesServiceProtocol {
    func sendVote(bodyData: Data, completion: @escaping ServiceCompletion)
}

final class VotesService: VotesServiceProtocol {
    let networkService: NetworkService = .shared

    func sendVote(bodyData: Data, completion: @escaping ServiceCompletion) {
        let (request, error) = networkService.createRequest(with: .post, body: bodyData, endpoint: "votes")
        guard error == nil, let breedImageRequest = request else {
            completion(.failure(.malformedURL))
            return
        }
        networkService.executeDataTask(with: breedImageRequest, completion: completion)
    }
}

