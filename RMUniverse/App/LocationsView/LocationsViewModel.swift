//
//  LocationsViewModel.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    // MARK: - Wrapped Properties

    @Published var locations: [Location] = []
    @Published var residents: [Character] = [] {
        didSet {
            isLoading = false
        }
    }
    @Published var errorMessage: String?
    @Published var isLoading = true

    // MARK: - Private Properties

    private let fetcher: FetchingProtocol?
    private var locationResponse: LocationResponse? {
        didSet {
            locations.append(contentsOf: locationResponse?.results ?? [])
        }
    }

    // MARK: - Initializers

    init(fetcher: FetchingProtocol?) {
        self.fetcher = fetcher
    }

    func fetchLocations() {
        Task {
            if let nextURL = locationResponse?.info.next {
                locationResponse = try await fetcher?.loadNextPage(url: nextURL, type: LocationResponse.self)
            } else {
                do {
                    locationResponse = try await fetcher?.fetchAllLocations()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func fetchResidents(for location: Location) {
        isLoading = true
        Task {
            do {
                guard let residents = try await fetcher?.fetchCharacters(for: location.residents) else { return }
                self.residents = residents
            } catch let error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
