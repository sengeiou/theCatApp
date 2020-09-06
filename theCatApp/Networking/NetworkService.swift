//
//  NetworkService.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import Foundation

typealias ServiceCompletion = (Result<Data, ServiceError>) -> Void
typealias DecodableCompletion = (Result<Any, ServiceError>) -> Void

enum ServiceError: Error {
    case noInternetConnection
    case timeOut
    case malformedURL
    case noDataReceived
    case parseData
    case other(String?)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkService {
    static var shared: NetworkService = NetworkService()
    private let urlSession = URLSession.shared
    let baseUrlString: String = "https://api.thecatapi.com/v1"
    private let apiKey: String = "df1939b4-6862-4db2-923d-09f555472841"

    private func createUrl(for endpoint: String) -> URL? {
        let urlString = "\(baseUrlString)/\(endpoint)"
        guard let url = URL(string: urlString) else {
                return nil
        }
        return url
    }

    func createRequest(with method: HTTPMethod, body: Data? = nil, endpoint: String) -> (URLRequest?, ServiceError?) {
        guard let url = createUrl(for: endpoint) else {
            return (nil, .malformedURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        if let bodyData = body {
            request.httpBody = bodyData
        }

        return (request, nil)
    }

    func executeDataTask(with request: URLRequest, completion: @escaping ServiceCompletion) {
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let serviceError: ServiceError
                switch (error as NSError?)?.code {
                case NSURLErrorNotConnectedToInternet:
                    serviceError = .noInternetConnection
                case NSURLErrorTimedOut:
                    serviceError = .timeOut
                default:
                    serviceError = .other(error?.localizedDescription)
                }
                completion(.failure(serviceError))
                return
            }
            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }

    func fetchImage(from urlString: String, completion: @escaping ServiceCompletion) {
        urlSession.getData(from: urlString) { (data, response, error) in
            guard error == nil else {
                let serviceError: ServiceError
                switch (error as NSError?)?.code {
                case NSURLErrorNotConnectedToInternet:
                    serviceError = .noInternetConnection
                case NSURLErrorTimedOut:
                    serviceError = .timeOut
                default:
                    serviceError = .other(error?.localizedDescription)
                }
                completion(.failure(serviceError))
                return
            }
            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            completion(.success(data))
        }
    }
}
