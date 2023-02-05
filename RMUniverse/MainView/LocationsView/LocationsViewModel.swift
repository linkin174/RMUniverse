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
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let fetcher: FetcherService
    private var locationResponse: LocationResponse? {
        didSet {
            locations.append(contentsOf: locationResponse?.results ?? [])
        }
    }

    // MARK: - Initializers

    init(fetcher: FetcherService) {
        self.fetcher = fetcher
    }

    func fetchLocations() {
        Task {
            if let nextURL = locationResponse?.info.next {
                locationResponse = try await fetcher.loadNextPage(url: nextURL, type: LocationResponse.self)
            } else {
                do {
                    locationResponse = try await fetcher.fetchAllLocations()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
