//
//  Untitled.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//

import Foundation
import Combine


@MainActor // All UI updates happen on the main thread
class CharacterViewModel: ObservableObject {

	@Published var character: [RMCharacter] = []
	@Published var searchText: String = ""
	@Published var isLoading: Bool = false
	@Published var errorMessage: String = ""
	
	private let apiService: RMAPIServices = RMAPIServices()
	
	private var currentPage: Int = 1
	private var totalPages: Int = 1
	
	func loadFirstPage() async {
		currentPage = 1
		totalPages = 1
		character = []
		errorMessage = ""
		
		await loadPage(page:currentPage, appendResults: false)
	}
	
	func loadNextPage() async {
		
		if isLoading == true {
			return
		}
	
		if currentPage < totalPages {
			currentPage += 1
			await loadPage(page:currentPage, appendResults: true)
		}
	}
	
	func canLoadMore() -> Bool {
		return currentPage < totalPages
	}
	
	private func loadPage(page: Int, appendResults: Bool) async {
		isLoading = true
		errorMessage = ""
		
		var nameFilter: String? = nil
		if searchText.isEmpty == false {
			nameFilter = searchText
		}
		
		do {
			let response:CharacterResponse = try await apiService.fetchCharacter(page: page, name: nameFilter)
			
			totalPages = response.info.pages
			
			if appendResults == true {
				character.append(contentsOf: response.results)
			} else {
				character = response.results
			}
		} catch let apiError as RMAPIError {
			if  apiError == RMAPIError.noResults {
				character = []
				errorMessage = "No characters found"
				totalPages = 1
			} else {
				errorMessage = "Network Error"
			}
		} catch {
			errorMessage = "Network Error"
		}
		
		isLoading = false
			
	}
}
