//
//  LocationDetailRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation

protocol LocationDetailRepository {
    func getLocationDetail(forLocationID locationID: String) async throws -> LocationDetail
}
