//
//  MainViewModel.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation
@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Wrapped Properties

    @Published var characters: [Character] = []
    @Published var error: String?

    // MARK: - Private properties
    private let fetcher: FetcherService

    // MARK: - Initializers
    
    init(fetcher: FetcherService) {
        self.fetcher = fetcher
    }

    // MARK: - Public Methods

    func fetchCharacters() {
        Task {
            do {
                characters = try await fetcher.getAllCharacters(page: nil)
            } catch let error {
                self.error = error.localizedDescription
            }
        }
    }
}
