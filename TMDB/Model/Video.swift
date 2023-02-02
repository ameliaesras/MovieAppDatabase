//
//  Video.swift
//  TMDB
//
//  Created by Amelia Esra S on 02/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation

struct VideoResponse: Decodable{
    let movieId: Int
    let results: [Video]
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case results
    }
}

struct Video: Decodable {
    let key: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case key, type
    }
}
