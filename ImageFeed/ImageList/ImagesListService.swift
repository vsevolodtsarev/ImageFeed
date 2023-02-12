//
//  ImageListServices.swift
//  ImageFeed
//
//  Created by Всеволод Царев on 09.02.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case description = "description"
        case likedByUser = "liked_by_user"
        case urls = "urls"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small : String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService{
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oAuthTokenStorage = OAuth2TokenStorage.shared
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = makeRequest(path: "/photos?page=\(nextPage)", httpMethod: "GET")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                for photo in photoResult.indices {
                    self.photos.append(Photo(
                        id: photoResult[photo].id,
                        size: CGSize(width: photoResult[photo].width, height: photoResult[photo].height),
                        createdAt: Date(),
                        welcomeDescription: photoResult[photo].description,
                        thumbImageURL: photoResult[photo].urls.thumb,
                        largeImageURL: photoResult[photo].urls.full,
                        isLiked: photoResult[photo].likedByUser))
                }
                NotificationCenter.default
                    .post(name: ImagesListService.DidChangeNotification, object: self)
                
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(path: String, httpMethod: String) -> URLRequest {
        var urlComponents = URLComponents()
        guard let url = urlComponents.url(relativeTo: defaultBaseURL) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        let token = oAuthTokenStorage.token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
