//
//  FavoritesLocalRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/6/23.
//

import Foundation

class FavoritesLocalRepository: FavoritesRepository {
    
    private var favorites = [Character]()
    
    func addFavorite(_ character: Character) async throws {
        guard !favorites.contains(where: { $0.id == character.id }) else { return }
        favorites.append(character)
    }
    
    func getFavorites() async throws -> [Character] {
        return favorites
    }
}