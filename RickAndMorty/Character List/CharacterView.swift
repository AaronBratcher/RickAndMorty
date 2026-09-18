//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import SwiftUI

struct CharacterView: View {
	let character: Character

    var body: some View {
		VStack(spacing: 4) {
			AsyncImage(url: URL(string: character.image)) { phase in
				switch phase {
				case .empty:
					Image(systemName: "person")
						.font(.largeTitle)
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
				case .failure:
					Image(systemName: "person")
						.font(.largeTitle)
				@unknown default:
					Image(systemName: "person")
						.font(.largeTitle)
				}
			}
			.aspectRatio(1, contentMode: .fit)

			Text(character.name)
				.font(.title3)
				.multilineTextAlignment(.center)
				.lineLimit(2)
		}
		.padding(4)
    }
}

#if DEBUG
#Preview {
	CharacterView(character: Character.mockCharacters(1)[0])
}
#endif
