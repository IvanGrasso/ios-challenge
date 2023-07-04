//
//  CharacterListWebAPIResponse.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

struct CharacterListWebAPIResponse: Decodable {
    let results: [CharacterWebAPIResult]
}
