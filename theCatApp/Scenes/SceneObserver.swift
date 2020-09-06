//
//  SceneObserver.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

protocol SceneObserver {
    func sceneDidLoad()
    func sceneWillAppear()
    func sceneDidAppear()
}

extension SceneObserver {
    func sceneDidLoad() { }
    func sceneWillAppear() { }
    func sceneDidAppear() { }
}
