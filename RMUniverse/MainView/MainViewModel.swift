//
//  MainViewModel.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Wrapped Properties

    @Published var characters: [Character] = []
    @Published var locations: [Location] = []
    @Published var errorMessage: String?
    private var characterResponse: CharacterResponse? {
        didSet {
            characters.append(contentsOf: characterResponse?.results ?? [])
        }
    }

    private var locationsResponse: LocationResponse? {
        didSet {
            locations = locationsResponse?.results ?? []
        }
    }

    // MARK: - Private properties

    private let fetcher: FetcherService

    // MARK: - Initializers

    init(fetcher: FetcherService) {
        self.fetcher = fetcher
//        fetchCharacters()
    }
}
