//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import SwiftUI

struct CharacterListView: View {
	@State var viewModel: CharacterListViewModel
	@State private var selectedCharacter: Character?

	private let columns = [GridItem(.adaptive(minimum: 85), spacing: 4)]

	init(viewModel: CharacterListViewModel = CharacterListViewModel()) {
		self.viewModel = viewModel
	}

    var body: some View {
		ZStack(alignment: .top) {
			switch viewModel.loadingState {
			case .idle, .complete:
				ScrollView {
					LazyVGrid(columns: columns, spacing: 4) {
						ForEach(viewModel.characters) { character in
							Button(action: {
								selectedCharacter = character
							}, label: {
								CharacterView(character: character)
							})
							.buttonStyle(.plain)
						}
					}
					.padding(4)
				}
				.padding(.top)
			case .error:
				errorLoading
			case .loading:
				loading
			}


			SearchView(searchText: $viewModel.searchText)
		}
		.sheet(item: $selectedCharacter) { character in
			CharacterDetailView(character: character)
		}
    }

	@ViewBuilder
	private var errorLoading: some View {
		VStack {
			Spacer()
			Text("Error loading list")
			Spacer()
		}
	}

	@ViewBuilder
	private var loading: some View {
		VStack {
			Spacer()
			ProgressView()
				.progressViewStyle(.circular)
			Spacer()
		}
	}
}

#Preview("8") {
	CharacterListView(viewModel: CharacterListViewModel(characters: Character.mockCharacters(8)))
}

#Preview("Zero") {
	CharacterListView(viewModel: CharacterListViewModel())
}
