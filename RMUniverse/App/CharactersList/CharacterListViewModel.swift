//
//  CharactersListViewModel.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import Foundation

@MainActor
final class CharacterListViewModel: ObservableObject {

    // MARK: - Wrapped Values

    @Published var characters = [Character]()
    @Published var searchResults = [Character]()
    @Published var errorMessage: String?
    @Published var isSearching = false

    // MARK: - Private Properties

    private let fetcher: FetchingProtocol?

    private var characterResponse: CharacterResponse? {
        didSet {
            if isSearching {
                searchResults.append(contentsOf: characterResponse?.results ?? [])
                
            } else {
                characters.append(contentsOf: characterResponse?.results ?? [])
            }
        }
    }

    // MARK: - Initializers

    init(fetcher: FetchingProtocol?) {
        self.fetcher = fetcher
    }

    // MARK: - Public Methods

    func fetchCharacters() {
        Task {
            if let next = characterResponse?.info.next {
                do {
                    characterResponse = try await fetcher?.loadNextPage(url: next, type: CharacterResponse.self)
                } catch {
                    errorMessage = error.localizedDescription
                }
            } else {
                do {
                    characterResponse = try await fetcher?.getAllCharacters()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func searchCharacters(request: String) {
        #warning("maybe simplify?")
        if !request.isEmpty {
            isSearching = true
            searchResults = characters.filter { $0.name.contains(request) }
        } else {
            isSearching = false
            searchResults.removeAll()
        }
    }
}
