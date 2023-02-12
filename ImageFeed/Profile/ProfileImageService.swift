//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 03.02.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageResult
    
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileImage):
                self.avatarURL = profileImage.profileImage.small
                completion(.success(profileImage.profileImage.small))
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImage.profileImage.small])
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String, username: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url(relativeTo: defaultBaseURL) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
