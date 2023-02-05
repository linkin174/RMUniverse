//
//  LocationResponse.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation

// MARK: - LocationResponse
struct LocationResponse: Codable {
    let info: Info
    let results: [Location]
}

// MARK: - Result
struct Location: Codable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
