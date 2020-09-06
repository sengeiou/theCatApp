//
//  VotesStorageManager.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation
import CoreData

final class VotesStorageManager: StorageManager {
    typealias StorableEntity = VotedCatEntity
    typealias Entity = VotedCatModel
    static var instance = VotesStorageManager()

    var context: NSManagedObjectContext?

    func parseToStorableEntity(entity: Entity) throws -> NSManagedObject {
        guard let context = context, let storableEntity = entity.parseToStorableEntity(context: context) as? StorableEntity else {
            throw StorageManagerError.contextUndefined
        }
        return storableEntity
    }

    func parseToEntity(storableEntity: StorableEntity) -> Entity {
        return Entity(storableEntity)
    }

    func getObjects() throws -> [Entity] {
        guard let context = context else {
            throw StorageManagerError.contextUndefined
        }
        var entities = [Entity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: StorableEntity.self))
        context.performAndWait {
            do {
                guard let objects = try context.fetch(fetchRequest) as? [StorableEntity] else {
                    throw StorageManagerError.parseError
                }
                entities = objects.map { Entity($0) }
            } catch {
                fatalError("It wasn't possible to fetch \(String(describing: Entity.self)), error:\(error)")
            }
        }
        return entities
    }
}

extension VotesFacade {
    static func inject() -> VotesStorageManager {
        VotesStorageManager.instance
    }
}
