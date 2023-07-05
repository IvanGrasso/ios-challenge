//
//  CharacterRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation

protocol CharacterRepository {
    func getCharacters(untilPage page: Int) async throws -> [Character]
}
