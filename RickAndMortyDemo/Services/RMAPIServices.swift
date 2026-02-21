//
//  RMApi.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//
import Foundation

enum RMAPIError: Error {
	case invalidURL
	case invalidResponse
	case noResults
	case badStatusCode
	case decodeFailed
}

class RMAPIServices {
	
	private  let baseURL: String = "https://rickandmortyapi.com/api/character"
	
	func fetchCharacter(page:Int, name: String? ) async throws -> CharacterResponse{
		
		//  Step 1: Build the URL safely using URLCOmponents
		guard var components: URLComponents = URLComponents(string: baseURL) else {
			throw RMAPIError.invalidURL
		}
		
		// Step 2: Add query parameters (page, and optional name)
		var queryItems: [URLQueryItem] = []
		
		queryItems.append(URLQueryItem(name: "page", value: String(page)))
		
		if let nameValue: String = name { // if its not nill or empty append the name param
			if nameValue.isEmpty == false {
				queryItems.append(URLQueryItem(name: "name", value: nameValue))
			}
		}
		
		// Step 3: Create the Final URL
		components.queryItems = queryItems
		
		guard let url: URL = components.url else {
			throw RMAPIError.invalidURL
		}
		
		// Step 4: Make the network request using URLSession
		let networkReq: (Data, URLResponse) = try await URLSession.shared.data(from: url)
		
		// Step 4.1: get the body of the response "JSON" aka "Data"
		let data: Data = networkReq.0
		
		// Step 4.2: get the headers and status
		let response: URLResponse = networkReq.1

		// Step 5: confirm we got a valid response (HTTP status code)
		guard let HTTPResponse: HTTPURLResponse = response as? HTTPURLResponse else {
			throw RMAPIError.invalidResponse
		}
		
		let statusCode: Int = HTTPResponse.statusCode
		
		if statusCode == 200 {
			// Good response
		} else if statusCode == 404 {
			// Missing page or not found
			throw RMAPIError.noResults
		} else {
			throw RMAPIError.badStatusCode
		}
		
		// Step 6: Decode the JSON into our Codable structs
		let decoder: JSONDecoder = JSONDecoder()
		
		do {
			let decodeResponse: CharacterResponse = try decoder.decode(CharacterResponse.self, from: data)
			
			print(decodeResponse)
			
			return decodeResponse
		} catch {
			throw RMAPIError.decodeFailed
		}
	}
}
