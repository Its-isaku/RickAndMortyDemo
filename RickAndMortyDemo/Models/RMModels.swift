//
//  RMModels.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//

import Foundation
import Combine

struct CharacterResponse: Codable {
	var info: PageInfo
	var results: [RMCharacter]
}

struct PageInfo: Codable {
	var count: Int
	var pages: Int
	var next: String?
	var prev: String?
}

struct RMCharacter: Codable, Identifiable {
	var id: Int
	var name: String
	var status: String
	var species: String
	var type: String
	var gender: String
	var image: String
	
	var origin: RMPlace
	var location: RMPlace
}

struct RMPlace: Codable {
	var name: String
	var url: String
}
