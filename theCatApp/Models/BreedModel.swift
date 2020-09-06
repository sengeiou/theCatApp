//
//  BreedModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

struct BreedWeight: Codable {
    var metric: String
    var imperial: String

    private enum CodingKeys: String, CodingKey {
        case metric, imperial
    }
}

struct BreedModel {
    var id: String
    var name: String
    var origin: String
    var lifeSpan: String
    var weight: BreedWeight
    var temperament: String
    var description: String
    var wikipediaUrl: String
    var breedImage: CatImageModel?
}

extension BreedModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, origin, weight, temperament, description
        case lifeSpan = "life_span"
        case wikipediaUrl = "wikipedia_url"
    }
}
