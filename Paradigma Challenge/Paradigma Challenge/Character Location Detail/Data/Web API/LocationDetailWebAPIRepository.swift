//
//  LocationDetailWebAPIRepository.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation

enum LocationDetailWebAPIRepositoryError: Error {
    case invalidURL
}

class LocationDetailWebAPIRepository: LocationDetailRepository {
    func getLocationDetail(forLocationID locationID: String) async throws -> LocationDetail {
        guard let url = URL(string: "\(LocationDetailWebAPIConstants.baseURL)\(LocationDetailWebAPIConstants.path)\(locationID)") else {
            throw ResultWebAPIRepositoryError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WebAPILocationDetail.self, from: data)
        let locationDetail = LocationDetail(webAPILocationDetail: response)
        return locationDetail
    }
}

private extension LocationDetail {
    init(webAPILocationDetail: WebAPILocationDetail) {
        self.id = webAPILocationDetail.id
        self.name = webAPILocationDetail.name
        self.type = webAPILocationDetail.type
        self.dimension = webAPILocationDetail.dimension
    }
}
