//
//  Artwork.swift
//  NetworkingHW
//
//  Created by testing on 11.11.2023.
//

import Foundation

struct  Artwork: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct Todos: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct ShowInfo: Decodable {
    let id: Int
    let url: String?
    let number: Int
    let name: String
    let episodeOrder: Int
    let premiereDate: String
    let endDate: String
}
