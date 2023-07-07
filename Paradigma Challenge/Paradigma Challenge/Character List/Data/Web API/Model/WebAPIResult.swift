//
//  WebAPIResult.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

struct WebAPIResult: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: ResultWebAPILocation
    let location: ResultWebAPILocation
    let image: String
}
