//
//  ResultWebAPIResponse.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/3/23.
//

import Foundation

struct ResultWebAPIResponse: Decodable {
    let results: [WebAPIResult]
    let info: WebAPIInfo
}
