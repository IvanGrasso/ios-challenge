//
//  MockResultRepository.swift
//  Paradigma ChallengeTests
//
//  Created by Ivan Grasso on 7/9/23.
//

import Foundation
@testable import Paradigma_Challenge

final class MockResultRepository: ResultRepository {
    
    var mockGetResults: ((_ page: Int) async throws -> [Paradigma_Challenge.Character])?
    
    func getResults(forPage page: Int) async throws -> [Paradigma_Challenge.Character] {
        return try await mockGetResults?(page) ?? []
    }
}
