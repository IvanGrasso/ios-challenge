//
//  Character.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation

struct Character: Hashable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: CharacterLocation?
    let location: CharacterLocation?
}
