import Foundation
import NetworkManager
@testable import RickAndMorty

final class MockCharacterDownloader: CharacterDownloading, @unchecked Sendable {
	private let lock = NSLock()
	private var _requestedSearchTexts: [String] = []

	var defaultResult: Result<[Character], DownloadError> = .success([])
	var responsesBySearchText: [String: (result: Result<[Character], DownloadError>, delayNanoseconds: UInt64)] = [:]

	var requestedSearchTexts: [String] {
		lock.lock()
		defer { lock.unlock() }
		return _requestedSearchTexts
	}

	func downloadCharacters(matching searchText: String) async -> Result<[Character], DownloadError> {
		lock.lock()
		_requestedSearchTexts.append(searchText)
		let response = responsesBySearchText[searchText]
		lock.unlock()

		if let delay = response?.delayNanoseconds, delay > 0 {
			try? await Task.sleep(nanoseconds: delay)
		}

		return response?.result ?? defaultResult
	}
}
