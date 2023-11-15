//
//  NetworkManager.swift
//  NetworkingHW
//
//  Created by testing on 15.11.2023.
//

import Foundation

enum Link {
    case photosURL
    case postsURL
    case todosURL
    case infoURL
    
    var url: URL! {
        switch self {
        case .photosURL:
            return URL(string: "https://jsonplaceholder.typicode.com/photos")
        case .postsURL:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")
        case .todosURL:
            return URL(string: "https://jsonplaceholder.typicode.com/todos")
        case .infoURL:
            return URL(string: "https://api.tvmaze.com/shows/1/seasons")
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success((object)))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
