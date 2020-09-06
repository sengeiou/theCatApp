//
//  StorageManager.swift
//  theCatApp
//
//  Created by Julián Granada on 6/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation
import CoreData

protocol Storable {
    var entityName: String { get }
    func parseToStorableEntity(context: NSManagedObjectContext) -> NSManagedObject?
}

enum StorageManagerError: Error {
    case contextNotFound
    case contextUndefined
    case parseError
}

protocol StorageManager {
    associatedtype StorableEntity: NSManagedObject
    associatedtype Entity: Storable
    var context: NSManagedObjectContext? { get set }

    mutating func setContext(_ context: NSManagedObjectContext)
    func parseToStorableEntity(entity: Entity) throws -> NSManagedObject
    func parseToEntity(storableEntity: StorableEntity) -> Entity
    func save(object: Entity) throws
    func getObjects() throws -> [Entity]
}

extension StorageManager {
    func save(object: Entity) throws {
        guard let context = context else {
            throw StorageManagerError.contextNotFound
        }
        context.performAndWait {
            do {
                let storableObject = try parseToStorableEntity(entity: object)
                context.insert(storableObject)
                try context.save()
            } catch {
                print("It wasn't possible to save \(Entity.self), error: \(error)")
            }
        }
    }

    mutating func setContext(_ context: NSManagedObjectContext) {
        self.context = context
    }
}
