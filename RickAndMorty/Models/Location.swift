//
//  Location.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation

struct Location: Codable {
    let id: Int?
    let name: String
    let type: String?
    let dimension: String?
    let residents: [String]?
    let url: String
    let created: String?
}
