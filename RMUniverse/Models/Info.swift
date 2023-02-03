//
//  Info.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?
}
