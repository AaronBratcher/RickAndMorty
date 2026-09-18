//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

import SwiftUI

struct CharacterDetailView: View {
	let character: Character
	
	private var formattedDate: String {
		// Parse the ISO8601 date string and format it nicely
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		
		if let date = isoFormatter.date(from: character.created) {
			let displayFormatter = DateFormatter()
			displayFormatter.dateStyle = .long
			displayFormatter.timeStyle = .short
			return displayFormatter.string(from: date)
		}
		
		return character.created
	}
	
	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				// Title
				Text(character.name)
					.font(.largeTitle)
					.fontWeight(.bold)
					.multilineTextAlignment(.center)
				
				// Character image - centered and full width
				AsyncImage(url: URL(string: character.image)) { phase in
					switch phase {
					case .empty:
						ProgressView()
							.frame(height: 300)
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
					case .failure:
						Image(systemName: "person.fill")
							.font(.system(size: 100))
							.foregroundStyle(.secondary)
							.frame(height: 300)
					@unknown default:
						Image(systemName: "person.fill")
							.font(.system(size: 100))
							.foregroundStyle(.secondary)
							.frame(height: 300)
					}
				}
				.frame(maxWidth: .infinity)
				
				VStack(alignment: .leading, spacing: 12) {
					// Species
					DetailRow(label: "Species", value: character.species)
					
					// Status
					DetailRow(label: "Status", value: character.status.rawValue)
					
					// Origin
					DetailRow(label: "Origin", value: character.origin.name)
					
					// Type - only show if available
					if !character.type.isEmpty {
						DetailRow(label: "Type", value: character.type)
					}
					
					// Created date
					DetailRow(label: "Created", value: formattedDate)
				}
				.padding(.horizontal)
			}
			.padding()
		}
		.presentationSizing(.fitted)
	}
}

// Helper view for consistent formatting
private struct DetailRow: View {
	let label: String
	let value: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(label)
				.font(.caption)
				.foregroundStyle(.secondary)
				.textCase(.uppercase)
			Text(value)
				.font(.body)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

#if DEBUG
#Preview {
	CharacterDetailView(character: Character.mockCharacters(1)[0])
}
#endif
