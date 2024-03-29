//
//  NetworkExtension.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 02.02.2023.
//

import Foundation

enum NetworkError: Error {
case httpStatusCode(Int)
case urlRequestError(Error)
case urlSessionError
}

extension URLSession {
    func objectTask<Model: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Model, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Model.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
