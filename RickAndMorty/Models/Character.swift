//
//  Character.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import Foundation

/// Represents a character from the Rick and Morty API
struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Character Status
enum CharacterStatus: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

// MARK: - Gender
enum Gender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

#if DEBUG
extension Character {
	static func mockCharacters(_ count: Int) -> [Character] {
		// Base set of 5 characters from the API response
		let baseCharacters: [Character] = [
			Character(
				id: 47,
				name: "Big Head Morty",
				status: .alive,
				species: "Human",
				type: "Human with giant head",
				gender: .male,
				origin: Location(name: "unknown", url: ""),
				location: Location(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
				image: "https://rickandmortyapi.com/api/character/avatar/47.jpeg",
				episode: ["https://rickandmortyapi.com/api/episode/28"],
				url: "https://rickandmortyapi.com/api/character/47",
				created: "2017-11-30T11:54:40.526Z"
			),
			Character(
				id: 48,
				name: "Big Boobed Waitress",
				status: .alive,
				species: "Mythological Creature",
				type: "",
				gender: .female,
				origin: Location(name: "Fantasy World", url: "https://rickandmortyapi.com/api/location/48"),
				location: Location(name: "Fantasy World", url: "https://rickandmortyapi.com/api/location/48"),
				image: "https://rickandmortyapi.com/api/character/avatar/48.jpeg",
				episode: ["https://rickandmortyapi.com/api/episode/13"],
				url: "https://rickandmortyapi.com/api/character/48",
				created: "2017-11-30T14:23:49.123Z"
			),
			Character(
				id: 56,
				name: "Birdperson",
				status: .dead,
				species: "Alien",
				type: "Bird-Person",
				gender: .male,
				origin: Location(name: "Bird World", url: "https://rickandmortyapi.com/api/location/15"),
				location: Location(name: "Planet Squanch", url: "https://rickandmortyapi.com/api/location/35"),
				image: "https://rickandmortyapi.com/api/character/avatar/56.jpeg",
				episode: [
					"https://rickandmortyapi.com/api/episode/11",
					"https://rickandmortyapi.com/api/episode/16",
					"https://rickandmortyapi.com/api/episode/21"
				],
				url: "https://rickandmortyapi.com/api/character/56",
				created: "2017-12-01T10:41:51.826Z"
			),
			Character(
				id: 78,
				name: "Butthole Ice Cream Guy",
				status: .alive,
				species: "Alien",
				type: "",
				gender: .male,
				origin: Location(name: "unknown", url: ""),
				location: Location(name: "Interdimensional Cable", url: "https://rickandmortyapi.com/api/location/6"),
				image: "https://rickandmortyapi.com/api/character/avatar/78.jpeg",
				episode: ["https://rickandmortyapi.com/api/episode/8"],
				url: "https://rickandmortyapi.com/api/character/78",
				created: "2017-12-02T17:05:39.459Z"
			),
			Character(
				id: 85,
				name: "Bill",
				status: .alive,
				species: "Human",
				type: "",
				gender: .male,
				origin: Location(name: "Earth (Replacement Dimension)", url: "https://rickandmortyapi.com/api/location/20"),
				location: Location(name: "Earth (Replacement Dimension)", url: "https://rickandmortyapi.com/api/location/20"),
				image: "https://rickandmortyapi.com/api/character/avatar/85.jpeg",
				episode: [
					"https://rickandmortyapi.com/api/episode/21",
					"https://rickandmortyapi.com/api/episode/23"
				],
				url: "https://rickandmortyapi.com/api/character/85",
				created: "2017-12-04T22:39:51.904Z"
			)
		]

		// Repeat the base characters to fill the requested count
		var result: [Character] = []
		for index in 0..<count {
			result.append(baseCharacters[index % baseCharacters.count])
		}

		return result
	}
}
#endif
