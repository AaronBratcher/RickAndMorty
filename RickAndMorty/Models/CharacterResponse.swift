//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import Foundation

/// Represents the paginated API response from the Rick and Morty API
struct CharacterResponse: Codable {
    let info: ResponseInfo
    let results: [Character]
}

// MARK: - Response Info
struct ResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
