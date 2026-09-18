//
//  Location.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import Foundation

/// Represents a location in the Rick and Morty universe
struct Location: Codable, Hashable {
    let name: String
    let url: String
}
