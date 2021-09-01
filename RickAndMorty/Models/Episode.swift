//
//  Episode.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name: String
    let releaseDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case episode = "episode"
        case releaseDate = "air_date"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
}
