import Foundation
import Testing
import NetworkManager
@testable import RickAndMorty

@Suite(.serialized)
struct CharacterListViewModelTests {

	private func waitUntil(timeout: TimeInterval = 3, _ condition: @escaping () -> Bool) async {
		let deadline = Date().addingTimeInterval(timeout)
		while !condition() && Date() < deadline {
			try? await Task.sleep(nanoseconds: 20_000_000)
		}
	}

	@Test func initialStateIsIdleAndEmpty() {
		let viewModel = CharacterListViewModel(networkManager: MockCharacterDownloader())

		#expect(viewModel.loadingState == .idle)
		#expect(viewModel.characters.isEmpty)
		#expect(viewModel.searchText.isEmpty)
	}

	@Test func emptySearchTextResetsAndCancelsPendingSearch() async {
		let mock = MockCharacterDownloader()
		mock.responsesBySearchText["a"] = (.success(Character.mockCharacters(1)), 0)
		let viewModel = CharacterListViewModel(networkManager: mock)

		viewModel.searchText = "a"
		viewModel.searchText = ""

		// Wait past the 0.4s debounce window "a" would have fired in, had it not been cancelled.
		try? await Task.sleep(nanoseconds: 600_000_000)

		#expect(mock.requestedSearchTexts.isEmpty)
		#expect(viewModel.characters.isEmpty)
		#expect(viewModel.loadingState == .idle)
	}

	@Test func debounceCollapsesRapidKeystrokesToFinalValue() async {
		let mock = MockCharacterDownloader()
		mock.responsesBySearchText["ab"] = (.success(Character.mockCharacters(2)), 0)
		let viewModel = CharacterListViewModel(networkManager: mock)

		viewModel.searchText = "a"
		viewModel.searchText = "ab"

		await waitUntil { viewModel.loadingState == .complete }

		#expect(mock.requestedSearchTexts == ["ab"])
		#expect(viewModel.characters.count == 2)
	}

	@Test func successfulSearchUpdatesCharactersAndCompletes() async {
		let expected = Character.mockCharacters(3)
		let mock = MockCharacterDownloader()
		mock.responsesBySearchText["rick"] = (.success(expected), 0)
		let viewModel = CharacterListViewModel(networkManager: mock)

		viewModel.searchText = "rick"

		await waitUntil { viewModel.loadingState == .complete }

		#expect(viewModel.characters == expected)
		#expect(viewModel.loadingState == .complete)
	}

	@Test func failedSearchSetsErrorState() async {
		let mock = MockCharacterDownloader()
		mock.responsesBySearchText["boom"] = (.failure(.download), 0)
		let viewModel = CharacterListViewModel(networkManager: mock)

		viewModel.searchText = "boom"

		await waitUntil { viewModel.loadingState == .error }

		#expect(viewModel.loadingState == .error)
		#expect(viewModel.characters.isEmpty)
	}

	/// Regression test: a slow response for an earlier query must never clobber
	/// results from a query typed after it.
	@Test func staleResponseDoesNotOverwriteNewerResults() async {
		let mock = MockCharacterDownloader()
		let staleCharacters = Character.mockCharacters(1)
		let freshCharacters = Character.mockCharacters(2)
		mock.responsesBySearchText["a"] = (.success(staleCharacters), 600_000_000)
		mock.responsesBySearchText["ab"] = (.success(freshCharacters), 50_000_000)
		let viewModel = CharacterListViewModel(networkManager: mock)

		viewModel.searchText = "a"
		// Wait for "a"'s debounce to fire and its (slow) network call to start.
		await waitUntil { mock.requestedSearchTexts.contains("a") }

		viewModel.searchText = "ab"

		await waitUntil(timeout: 2) {
			viewModel.loadingState == .complete && mock.requestedSearchTexts.contains("ab")
		}
		// Give the slow "a" response time to resolve, in case it (incorrectly) overwrites state.
		try? await Task.sleep(nanoseconds: 700_000_000)

		#expect(mock.requestedSearchTexts == ["a", "ab"])
		#expect(viewModel.characters == freshCharacters)
	}
}
