//
//  CharacterWebAPIRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

enum CharacterWebAPIRepositoryError: Error {
    case invalidURL
}

class CharacterWebAPIRepository: CharacterRepository {
    
    private var characters = [Character]()
    
    func getCharacters(untilPage page: Int) async throws -> [Character] {
        guard let url = URL(string: "\(CharacterWebAPIConstants.baseURL)\(CharacterWebAPIConstants.path)\(page)") else {
            throw CharacterWebAPIRepositoryError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CharacterListWebAPIResponse.self, from: data)
        characters.append(contentsOf: response.results.map { return Character(webAPIResult: $0) })
        return characters
    }
    
    func getFavorites() async throws -> [Character] {
        return []
    }
}

private extension Character {
    init(webAPIResult: CharacterWebAPIResult) {
        self.id = webAPIResult.id
        self.name = webAPIResult.name
        self.status = webAPIResult.status
        self.species = webAPIResult.species
        self.gender = webAPIResult.gender
        self.origin = CharacterLocation(webAPILocation: webAPIResult.origin)
        self.location = CharacterLocation(webAPILocation: webAPIResult.location)
    }
}

private extension CharacterLocation {
    init(webAPILocation: CharacterWebAPILocation) {
        self.name = webAPILocation.name
        self.url = webAPILocation.url
    }
}
