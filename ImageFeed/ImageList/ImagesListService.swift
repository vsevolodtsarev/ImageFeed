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

struct LikeResult: Decodable {
    let photo: PhotoResult
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
        
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = (lastLoadedPage ?? 0) + 1
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = makeRequest(path: "/photos?page=\(nextPage)&&per_page=10")
        request.httpMethod = "GET"
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
//                assertionFailure("\(error)")
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = makeRequest(path: "/photos/\(photoId)/like")
        if isLike {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        
        urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        fullImageURL: photo.fullImageURL,
                        isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(
        path: String) -> URLRequest {
            guard let baseURL = URL(string: path, relativeTo: DefaultBaseURL) else {
                assertionFailure("url is nil")
                return URLRequest(url: URL(string: "")!)
            }
            var request = URLRequest(url: baseURL)
            guard let token = OAuth2TokenStorage().token else {
                assertionFailure("token is nil")
                return URLRequest(url: URL(string: "")!)
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
}
