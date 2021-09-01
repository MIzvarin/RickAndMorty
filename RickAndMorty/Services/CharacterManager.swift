//
//  CharacterManager.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Alamofire

enum CharacterManager: URLRequestBuilder {
    case getAllCharacters
    case getSpecificCharacter(characterID: Int)
    
    var path: String { return "character"}
    
    var parameters: Parameters? {
        switch self {
        case .getAllCharacters:
            return nil
        case .getSpecificCharacter(let characterID):
            return ["id": characterID]
        }
    }
}
