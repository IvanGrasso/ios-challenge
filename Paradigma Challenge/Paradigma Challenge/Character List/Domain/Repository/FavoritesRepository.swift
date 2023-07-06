//
//  FavoritesRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/6/23.
//

import Foundation

protocol FavoritesRepository {
    func addFavorite(_ character: Character) async throws
    func getFavorites() async throws -> [Character]
}
