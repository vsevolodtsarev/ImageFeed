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
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case id, width, height, description, urls
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
    let fullImageURL: String
    let isLiked: Bool
}

final class ImagesListService{
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = (lastLoadedPage ?? 0) + 1

        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = makeRequest(path: "/photos?page=\(nextPage)&&per_page=10", httpMethod: "GET")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                photoResult.forEach { photoResult in
                    let photo = Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt),
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        fullImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser)
                    self.photos.append(photo)
                }

                NotificationCenter.default
                    .post(name: ImagesListService.didChangeNotification,
                          object: self,
                          userInfo: ["photos": self.photos])
                
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(
            path: String,
            httpMethod: String) -> URLRequest {
                guard let baseURL = URL(string: path, relativeTo: defaultBaseURL) else { fatalError("url is nil") }
                var request = URLRequest(url: baseURL)
                guard let token = OAuth2TokenStorage().token else { fatalError("token is nil")}
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = httpMethod
                return request
        }
    
}
