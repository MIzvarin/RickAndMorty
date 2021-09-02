//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Alamofire


struct NetworkManager {
    static let shared = NetworkManager()
    
    func loadModel<T: URLRequestBuilder, U: Codable>(service: T, decodeTo: U.Type, completion: @escaping (Result<U>) -> Void) {
        guard let request = service.urlRequest else { return }
        AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: U.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.fail(error))
            }
        }
    }
    
    func loadData(from url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        AF.request(url).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadModel<T: Codable>(from url: String, decodeTo: T.Type, completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: url) else { return }
        AF.request(url).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
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
