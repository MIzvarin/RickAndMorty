//
//  SubjectsList.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import Foundation


struct SubjectsList<T: Codable>: Codable {
    let info: Info
    let results: [T]
}
