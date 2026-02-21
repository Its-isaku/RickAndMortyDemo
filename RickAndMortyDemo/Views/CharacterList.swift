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
                List {
                    // Error message at top as a section header-like row
                    if viewModel.errorMessage.isEmpty == false {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }

                    ForEach(viewModel.character) { character in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                if let url = URL(string: character.image) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(character.name)
                                        .font(.headline)
                                    Text("\(character.status) - \(character.species)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .listRowSeparator(.visible)
                    }

                    if viewModel.canLoadMore() {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Button("Load More") {
                                    Task { await viewModel.loadNextPage() }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)

                if viewModel.isLoading && viewModel.character.isEmpty {
                    ProgressView("Loading...")
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
					await  viewModel.loadFirstPage()
					print (viewModel.character)
				}
			}
		}
    }
}

#Preview {
    CharacterList()
}
