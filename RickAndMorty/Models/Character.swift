//
//  Character.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation

class Character: Codable {
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
    var isFavorite: Bool {
        get {
            return StorageManager.shared.fetchCharacterByURL(url: url) != nil
        }
        set {
            
        }
    }
    
    var description: String {
        """
        \(statusAndSpeciesText)
        name: \(name)
        gender: \(gender)
        created: \(created)
        origin: \(origin?.name ?? "Undefinied")
        location: \(location?.name ?? "Undefinied")
        """
    }
    
    private func stringToDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:string)
        return date
    }
}
