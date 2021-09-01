//
//  Character.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location?
    let location: Location?
    let image: String
    let episode: [String]
    let url: String
    let created: String
    var isAlive: Bool {
        return status == "Alive"
    }
    var statusAndSpeciesText: String {
        if isAlive {
            return "🟢 \(status) - \(species)"
        } else {
            return "🔴 \(status) - \(species)"
        }
    }
}
