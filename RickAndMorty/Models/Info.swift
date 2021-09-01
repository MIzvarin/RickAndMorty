//
//  Info.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
