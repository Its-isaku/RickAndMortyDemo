//
//  CharacterNotes.swift
//  RickAndMortyDemo
//
//  Created by Isai Magdaleno Almeraz Landeros on 21/02/26.
//

import Foundation

class CharacterNotes {
		
	private let userDefaults: UserDefaults = UserDefaults.standard
	
	private func makeKey (characterId: Int) -> String {
		return "character_note_\(characterId)"
	}
	
	func saveNote(characterId: Int, note: String) {
		let key: String = makeKey(characterId: characterId)
		userDefaults.set(note, forKey: key)
	}
	
	func loadNote(characterId: Int) -> String {
		let key: String = makeKey(characterId: characterId)
		let savedNote: String? = userDefaults.string(forKey: key)
		
		if let note = savedNote {
			return note
		} else {
			return ""
		}
	}
	
	func clearNote(characterId: Int) {
		let key: String =  makeKey(characterId: characterId)
		userDefaults.removeObject(forKey: key)
	}
	
}
