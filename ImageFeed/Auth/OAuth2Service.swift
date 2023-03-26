//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 07.01.2023.
//

import Foundation

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let responseBody):
                let authToken = responseBody.accessToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest {
        let tokenURLString = "https://unsplash.com/oauth/token"
        var urlComponents = URLComponents(string: tokenURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
