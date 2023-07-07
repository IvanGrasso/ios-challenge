//
//  ResultWebAPIRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

enum ResultWebAPIRepositoryError: Error {
    case invalidURL
}

class ResultWebAPIRepository: ResultRepository {
        
    func getResults(forPage page: Int) async throws -> [Character] {
        guard let url = URL(string: "\(ResultWebAPIConstants.baseURL)\(ResultWebAPIConstants.path)\(page)") else {
            throw ResultWebAPIRepositoryError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ResultWebAPIResponse.self, from: data)
        return response.results.map { return Character(webAPIResult: $0) }
    }
    
    func getFavorites() async throws -> [Character] {
        return []
    }
}

private extension Character {
    init(webAPIResult: WebAPIResult) {
        self.id = webAPIResult.id
        self.name = webAPIResult.name
        self.status = webAPIResult.status
        self.species = webAPIResult.species
        self.gender = webAPIResult.gender
        self.origin = CharacterLocation(webAPILocation: webAPIResult.origin)
        self.location = CharacterLocation(webAPILocation: webAPIResult.location)
        self.image = webAPIResult.image
    }
}

private extension CharacterLocation {
    init?(webAPILocation: ResultWebAPILocation) {
        guard let range = webAPILocation.url.range(of: "/location/") else { return nil }
        let locationID = webAPILocation.url[range.upperBound...]
        self.name = webAPILocation.name
        self.id = String(locationID)
    }
}
