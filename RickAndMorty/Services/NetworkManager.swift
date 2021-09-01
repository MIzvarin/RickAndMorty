//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Alamofire


struct NetworkManager {
    static let shared = NetworkManager()
    
    func loadData<T: URLRequestBuilder, U: Codable>(service: T, decodeTo: U.Type, completion: @escaping (Result<U>) -> Void) {
        guard let request = service.urlRequest else { return }
        print(request.url)
        AF.request(request).validate().responseDecodable(of: U.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.fail(error))
            }
        }
    }
    
    private init() {}
}

enum Result<T: Codable> {
    case success(T)
    case fail(Error)
}
