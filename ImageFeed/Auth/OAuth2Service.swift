//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 07.01.2023.
//

import Foundation

final class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://unsplash.com/oauth/token"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
                return
            }
            
            if let data = data {
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    completion(.success(responseBody.accessToken))
                    
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
