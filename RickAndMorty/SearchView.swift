//
//  SearchView.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//
//

import SwiftUI
import Localizations

public struct SearchView: View {
	@Binding var searchText: String

	public init(searchText: Binding<String>) {
		_searchText = searchText
	}

	@FocusState var searchFocused: Bool?

	public var body: some View {
		GlassEffectContainer(spacing: 12) {
			VStack(alignment: .leading, spacing: 10) {
				HStack(spacing: 8) {
					searchField
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
						.glassEffect(.regular, in: Capsule())
						.overlay {
							Capsule()
								.stroke(Color.accentColor, lineWidth: 2.5)
								.opacity(searchFocused == true ? 1 : 0)
						}
						.animation(.easeInOut(duration: 0.15), value: searchFocused)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	var searchField: some View {
		HStack(spacing: 6) {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(.secondary)

			TextField("search.field.placeholder".localized, text: $searchText)
				.focused($searchFocused, equals: true)
				.onKeyPress(.escape) {
					searchFocused = nil
					return .handled
				}
				.onAppear {
					searchFocused = true
				}
				.toolbar {
					ToolbarItemGroup(placement: .keyboard) {
						Spacer()
						Button {
							searchFocused = nil
						} label: {
							Image(systemName: "keyboard.chevron.compact.down")
						}
					}
				}
			
		}
		.frame(maxWidth: .infinity)
	}
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
	@Previewable @State var searchText = ""

	VStack {
		SearchView(searchText: $searchText)
	}
	.padding()
}
#endif
