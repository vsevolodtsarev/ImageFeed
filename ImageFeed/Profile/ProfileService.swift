//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 19.01.2023.
//

import Foundation

struct Profile: Decodable {
    
    let username: String
    let name: String
    var loginName: String {"@\(username)"}
    let bio: String

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case bio = "bio"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.name = try container.decode(String.self, forKey: .name)
        self.bio = try container.decode(String.self, forKey: .bio)
    }
}

final class ProfileService {
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
    }
    
    private func makeRequest(token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.path = "/me"
        guard let url = urlComponents.url(relativeTo: defaultBaseURL) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
