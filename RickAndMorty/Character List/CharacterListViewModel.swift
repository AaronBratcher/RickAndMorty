//
//  Untitled.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//
import Foundation
import Observation
import NetworkManager

protocol CharacterDownloading: Sendable {
	func downloadCharacters(matching searchText: String) async -> Result<[Character], DownloadError>
}

@Observable
final class CharacterListViewModel {
	var searchText: String = "" {
		didSet {
			findCharacters(with: searchText)
		}
	}
	var characters: [Character] = []
	var loadingState: LoadingState = .idle

	private var inputTask: Task<Void, Never>?
	private var lastSearchTime: Date?
	private let networkManager: any CharacterDownloading
	private var searchTask: Task<Void, Never>?

	init(networkManager: any CharacterDownloading = NetworkManager.shared, characters: [Character] = []) {
		self.networkManager = networkManager
		self.characters = characters
	}
	
	func findCharacters(with text: String) {
		inputTask?.cancel()

		// Check if it's been at least 1 second since the last search
		let shouldSearchImmediately: Bool
		if let lastSearch = lastSearchTime {
			shouldSearchImmediately = Date().timeIntervalSince(lastSearch) >= 1.0
		} else {
			shouldSearchImmediately = false
		}
		
		inputTask = Task {
			if !shouldSearchImmediately {
				try? await Task.sleep(for: .seconds(0.4))
			}
			guard !Task.isCancelled else { return }
			await self.search(for: text)
		}
	}

	private func search(for text: String) async {
		lastSearchTime = Date()

		searchTask?.cancel()
		searchTask = nil
		
		searchTask = Task<Void, Never> { [weak self] in
			guard !Task.isCancelled else { return }
			guard let self else { return }

			self.loadingState = .loading
			let results = await networkManager.downloadCharacters(matching: text)
			guard !Task.isCancelled else { return }

			switch results {
			case .failure:
				self.loadingState = .error
			case .success(let characters):
				self.characters = characters
				self.loadingState = .complete
			}
		}
	}
}

