//
//  WebAPILocationDetail.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation

struct WebAPILocationDetail: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}
