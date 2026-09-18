//
//  CharacterApiData.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import Foundation
import NetworkManager
import OSLog

extension NetworkManager: CharacterDownloading {
	typealias CharacterDownloadResults = Result<[Character], DownloadError>
	func downloadCharacters(matching searchText: String) async -> CharacterDownloadResults {
		let logger = Logger(subsystem: NetworkManager.subsystem, category: "Chracters")
		do {
			let characterResponse: CharacterResponse = try await retrieveData(using: CharacterApiData(parameters: ["name": searchText]))
			logger.info("characters downloaded")
			return .success(characterResponse.results)
		} catch DownloadError.invalidUrl {
			logger.error("Invalid URL")
			return .failure(.invalidUrl)
		} catch DownloadError.parse {
			logger.error("Error parsing")
			return .failure(.parse)
		} catch {
			logger.error("Cannot download")
			return .failure(.download)
		}
	}
}

struct CharacterApiData: ProvidesApiInfo {
	var baseUrl: String { "https://rickandmortyapi.com/api/character/" }
	var parameters: [String : String]
	var decoder: JSONDecoder { JSONDecoder() }

	init(parameters: [String : String]) {
		self.parameters = parameters
	}
}
