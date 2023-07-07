//
//  ResultRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation

protocol ResultRepository {
    func getResults(forPage page: Int) async throws -> [Character]
}
