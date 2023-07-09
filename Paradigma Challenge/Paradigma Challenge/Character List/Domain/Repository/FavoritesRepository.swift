//
//  FavoritesRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/6/23.
//

import Foundation

protocol FavoritesRepository {
    func getFavorites() async throws -> [Character]
    func addFavorite(_ character: Character) async throws
    func removeFarite(_ character: Character) async throws
}
