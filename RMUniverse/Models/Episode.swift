//
//  Episode.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
