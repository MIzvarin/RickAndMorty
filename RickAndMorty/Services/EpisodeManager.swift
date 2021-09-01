//
//  EpisodeManager.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Alamofire

enum EpisodeManager: URLRequestBuilder {
    case getAllEpisodes
    case getSpecificEpisode(episodeID: Int)
    
    var path: String { return "episode"}
    
    var parameters: Parameters? {
        switch self {
        case .getAllEpisodes:
            return nil
        case .getSpecificEpisode(let episodeID):
            return ["id": episodeID]
        }
    }
}
