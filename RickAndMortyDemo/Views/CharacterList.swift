//
//  CharacterList.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//

import SwiftUI

struct CharacterList: View {
	@StateObject private var viewModel: CharacterViewModel = CharacterViewModel()

	var body: some View {
		NavigationStack {
			ZStack {
				// Background color
				Color(.systemGroupedBackground)
					.ignoresSafeArea()

				List {
					// Error message
					if viewModel.errorMessage.isEmpty == false {
						HStack {
							Image(systemName: "exclamationmark.triangle.fill")
								.foregroundStyle(.orange)
							Text(viewModel.errorMessage)
								.font(.subheadline)
								.foregroundStyle(.secondary)
						}
						.padding(.vertical, 8)
						.listRowBackground(Color.orange.opacity(0.1))
					}

					ForEach(viewModel.character) { character in
						NavigationLink(destination: CharacterDetail(character: character)) {
							CharacterRow(character: character)
						}
						.listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
					}

					// Load More
					if viewModel.canLoadMore() {
						HStack {
							Spacer()
							if viewModel.isLoading {
								ProgressView()
									.tint(Color(red: 0.59, green: 0.81, blue: 0.30))
							} else {
								Button {
									Task { await viewModel.loadNextPage() }
								} label: {
									Text("Load More")
										.font(.subheadline)
										.fontWeight(.semibold)
										.foregroundStyle(.white)
										.padding(.horizontal, 24)
										.padding(.vertical, 10)
										.background(Color(red: 0.59, green: 0.81, blue: 0.30))
										.clipShape(Capsule())
								}
							}
							Spacer()
						}
						.padding(.vertical, 8)
						.listRowBackground(Color.clear)
					}
				}
				.listStyle(.plain)

				// Loading state
				if viewModel.isLoading && viewModel.character.isEmpty {
					VStack(spacing: 16) {
						ProgressView()
							.scaleEffect(1.2)
							.tint(Color(red: 0.59, green: 0.81, blue: 0.30))
						Text("Loading characters...")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
				}
			}
			.navigationTitle("Characters")
		}
		.searchable(text: $viewModel.searchText, prompt: "Search by name")
		.onSubmit(of: .search) {
			Task { await viewModel.loadFirstPage() }
		}
		.onAppear {
			if viewModel.character.isEmpty == true {
				Task {
					await viewModel.loadFirstPage()
					print(viewModel.character)
				}
			}
		}
	}
}

// MARK: - Character Row

struct CharacterRow: View {
	let character: RMCharacter

	var body: some View {
		HStack(spacing: 14) {
			// Character image
			if let url = URL(string: character.image) {
				AsyncImage(url: url) { image in
					image
						.resizable()
						.scaledToFill()
				} placeholder: {
					RoundedRectangle(cornerRadius: 14)
						.fill(Color.gray.opacity(0.2))
						.overlay {
							ProgressView()
						}
				}
				.frame(width: 70, height: 70)
				.clipShape(RoundedRectangle(cornerRadius: 14))
			}

			// Character info
			VStack(alignment: .leading, spacing: 5) {
				Text(character.name)
					.font(.headline)
					.lineLimit(1)

				// Status with colored dot
				HStack(spacing: 6) {
					Circle()
						.fill(statusColor(for: character.status))
						.frame(width: 8, height: 8)

					Text(character.status)
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}

				Text(character.species)
					.font(.caption)
					.foregroundStyle(.tertiary)
			}

			Spacer(minLength: 0)
		}
		.padding(.vertical, 4)
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

#Preview {
	CharacterList()
}
