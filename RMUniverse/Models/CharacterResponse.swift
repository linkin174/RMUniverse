//
//  Response.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation

// MARK: - Response
struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Character
struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String

    static var placeholder: Character {
        Character(id: 1,
                  name: "Rick Sanchez",
                  status: "Alive",
                  species: "Human",
                  type: "",
                  gender: "Male",
                  origin: CharacterLocation(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                  location: CharacterLocation(name: "Citadel Of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
                  image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                  episode: [
                    "https://rickandmortyapi.com/api/episode/1",
                        "https://rickandmortyapi.com/api/episode/2",
                        "https://rickandmortyapi.com/api/episode/3"
                  ],
                  url: "https://rickandmortyapi.com/api/character/1",
                  created: "2017-11-04T18:48:46.250Z")
    }
}

// MARK: - Location
struct CharacterLocation: Codable {
    let name: String
    let url: String
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

