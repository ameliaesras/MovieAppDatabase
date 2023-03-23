//
//  Review.swift
//  TMDB
//
//  Created by Amelia Esra Sihombing on 22/03/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation

//struct ReviewResponse: Decodable {
//    let page: Int
//    let results: [Reviews]
//    let totalPages: Int
//
//    enum codingKeys: String, CodingKey {
//        case page
//        case results
//        case totalPages = "total_pages"
//    }
//}
//
//struct Reviews: Decodable {
//    let authorDetails: Author
//    let content: String
//    let url: String
//    let updateAt: String
//
//    enum codingKeys: String, CodingKey {
//        case authorDetails = "author_details"
//        case content, url
//        case updateAt = "updated_at"
//    }
//}
//
//struct Author: Decodable {
//    let name: String
//    let username: String
//    let avatarPath: String?
//    let rating: Int?
//
//    enum codingKeys: String, CodingKey {
//        case name, username, rating
//        case avatarPath = "avatar_path"
//    }
//}

// MARK: - ReviewResponse
struct ReviewResponse: Codable {
    let id, page: Int
    let results: [Reviews]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Reviews: Codable {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }
}

