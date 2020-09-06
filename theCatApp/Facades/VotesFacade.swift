//
//  VotesFacade.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol VotesFacadeProtocol {
    func sendVote(imageId: String, like: Bool, completion: @escaping DecodableCompletion)
    func saveVoteToStorage(votedCatModel: VotedCatModel)
}

final class VotesFacade {
    static let instance = VotesFacade()
    private lazy var encoder: JSONEncoder = .init()
    private let service: VotesServiceProtocol
    private let votesStorageManager: VotesStorageManager

    init(service: VotesServiceProtocol = VotesService(),
         votesStorageManager: VotesStorageManager = inject()) {
        self.service = service
        self.votesStorageManager = votesStorageManager
    }
}

extension VotesFacade: VotesFacadeProtocol {
    func sendVote(imageId: String, like: Bool, completion: @escaping DecodableCompletion) {
        guard let bodyData = encodeVote(from: SendVoteServiceBody(imageId: imageId, value: like ? 1 : 0)) else {
            return
        }
        service.sendVote(bodyData: bodyData) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func encodeVote(from information: SendVoteServiceBody) -> Data? {
        do {
            return try encoder.encode(information)
        } catch {
            return nil
        }
    }

    func saveVoteToStorage(votedCatModel: VotedCatModel) {
        do {
            try votesStorageManager.save(object: votedCatModel)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MVPPresenter {
    static func inject() -> VotesFacadeProtocol {
        VotesFacade.instance
    }
}
