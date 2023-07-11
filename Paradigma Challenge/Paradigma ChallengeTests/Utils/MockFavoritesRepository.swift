//
//  MockFavoritesRepository.swift
//  Paradigma ChallengeTests
//
//  Created by Ivan Grasso on 7/9/23.
//

import Foundation
@testable import Paradigma_Challenge

final class MockFavoritesRepository: FavoritesRepository {
    func getFavorites() async throws -> [Paradigma_Challenge.Character] {
        return []
    }
    
    func addFavorite(_ character: Paradigma_Challenge.Character) async throws {
        
    }
    
    func removeFavorite(_ character: Paradigma_Challenge.Character) async throws {
        
    }
}
