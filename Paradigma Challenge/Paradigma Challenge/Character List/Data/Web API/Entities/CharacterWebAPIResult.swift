//
//  CharacterWebAPIResult.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

struct CharacterWebAPIResult: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: CharacterWebAPILocation
    let location: CharacterWebAPILocation
}
