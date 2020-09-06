//
//  VotedCatModel.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation
import CoreData

enum VoteType: String {
    case like
    case dislike
    case unknown = ""
}

struct VotedCatModel {
    var date: Date?
    var imageUrl: String?
    var name: String?
    var vote: VoteType
}

extension VotedCatModel {
    init(_ storableEntity: VotedCatEntity) {
        self.date = storableEntity.date
        self.imageUrl = storableEntity.imageUrl
        self.name = storableEntity.name
        self.vote = VoteType(rawValue: storableEntity.vote ?? "") ?? .unknown
    }
}

extension VotedCatModel: Storable {
    var entityName: String {
        "VotedCatEntity"
    }

    func parseToStorableEntity(context: NSManagedObjectContext) -> NSManagedObject? {
        guard let storedEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return nil
        }
        let entity = NSManagedObject(entity: storedEntity, insertInto: context)
        entity.setValue(date, forKey: "date")
        entity.setValue(imageUrl, forKey: "imageUrl")
        entity.setValue(name, forKey: "name")
        entity.setValue(vote.rawValue, forKey: "vote")
        return entity
    }
}
