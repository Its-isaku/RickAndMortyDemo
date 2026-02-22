//
//  CharacterDetail.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//

import SwiftUI

struct CharacterDetail: View {
	let character: RMCharacter

	var body: some View {
		ScrollView {
			VStack(spacing: 0) {

				// MARK: - Hero Image
				ZStack(alignment: .bottomLeading) {
					if let url = URL(string: character.image) {
						AsyncImage(url: url) { image in
							image
								.resizable()
								.scaledToFill()
						} placeholder: {
							Rectangle()
								.fill(Color.gray.opacity(0.2))
								.overlay {
									ProgressView()
								}
						}
						.frame(height: 320)
						.clipped()
					}

					// Gradient overlay at the bottom of the image
					LinearGradient(
						colors: [.clear, .black.opacity(0.7)],
						startPoint: .center,
						endPoint: .bottom
					)
					.frame(height: 160)
					.frame(maxWidth: .infinity)

					// Name on top of the image
					VStack(alignment: .leading, spacing: 6) {
						Text(character.name)
							.font(.title)
							.fontWeight(.bold)
							.foregroundStyle(.white)

						// Status badge
						HStack(spacing: 6) {
							Circle()
								.fill(statusColor(for: character.status))
								.frame(width: 10, height: 10)

							Text("\(character.status) - \(character.species)")
								.font(.subheadline)
								.foregroundStyle(.white.opacity(0.9))
						}
					}
					.padding(20)
				}

				// MARK: - Info Cards
				VStack(spacing: 16) {

					// Gender & Species
					HStack(spacing: 12) {
						InfoCard(
							icon: "person.fill",
							title: "Gender",
							value: character.gender
						)
						InfoCard(
							icon: "pawprint.fill",
							title: "Species",
							value: character.species
						)
					}

					// Type (only show if not empty)
					if character.type.isEmpty == false {
						InfoCard(
							icon: "tag.fill",
							title: "Type",
							value: character.type
						)
						.frame(maxWidth: .infinity)
					}

					// Origin
					InfoCard(
						icon: "globe.americas.fill",
						title: "Origin",
						value: character.origin.name
					)
					.frame(maxWidth: .infinity)

					// Last Known Location
					InfoCard(
						icon: "mappin.and.ellipse",
						title: "Last Known Location",
						value: character.location.name
					)
					.frame(maxWidth: .infinity)
				}
				.padding(20)
			}
		}
		.ignoresSafeArea(edges: .top)
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(.hidden, for: .navigationBar)
	}

	func statusColor(for status: String) -> Color {
		switch status.lowercased() {
		case "alive":
			return .green
		case "dead":
			return .red
		default:
			return .gray
		}
	}
}

// MARK: - Info Card

struct InfoCard: View {
	let icon: String
	let title: String
	let value: String

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 6) {
				Image(systemName: icon)
					.font(.caption)
					.foregroundStyle(Color(red: 0.59, green: 0.81, blue: 0.30))

				Text(title.uppercased())
					.font(.caption)
					.fontWeight(.semibold)
					.foregroundStyle(.secondary)
			}

			Text(value)
				.font(.body)
				.fontWeight(.medium)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(14)
		.background(Color(.secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

#Preview {
	NavigationStack {
		CharacterDetail(character: RMCharacter(
			id: 1,
			name: "Rick Sanchez",
			status: "Alive",
			species: "Human",
			type: "",
			gender: "Male",
			image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
			origin: RMPlace(name: "Earth (C-137)", url: ""),
			location: RMPlace(name: "Citadel of Ricks", url: "")
		))
	}
}
