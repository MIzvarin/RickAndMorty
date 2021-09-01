//
//  URLRequestBuilder.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension URLRequestBuilder {
    var baseURL: String {
        "https://rickandmortyapi.com/api"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request = try  URLEncoding.default.encode(request, with: parameters)
        return request
    }
}
