//
//  CatImageModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct CatImageModel {
    var id: String
    var url: String
    var image: UIImage?
    var width: Int
    var height: Int
}

extension CatImageModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, url, width, height
    }

    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        let container = try unkeyedContainer.nestedContainer(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
}
