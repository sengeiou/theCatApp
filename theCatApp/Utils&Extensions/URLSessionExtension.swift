//
//  URLSessionExtension.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

extension URLSession {
    func getData(from urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        dataTask(with: url, completionHandler: completion).resume()
    }
}
