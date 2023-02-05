//
//  FetcherService.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation

final class FetcherService {
    // MARK: - Private Properties

    private let networkService: NetworkService

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Initializers
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    func getAllCharacters(page: Int? = nil) async throws -> CharacterResponse {
        do {
            let parameters = makeParameters(for: page)
            let data = try await networkService.request(path: API.getCharacters, parameters: parameters)
            guard let response = try? decoder.decode(CharacterResponse.self, from: data) else { throw APIError.badDecoding }
            print(response.results.map { $0.name })
            return response
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }

    func loadNextPage<T: Codable>(url: String, type: T.Type) async throws -> T {
        do {
            guard let url = URL(string: url) else { throw APIError.badURL }
            let data = try await networkService.requset(from: url)
            guard let response = try? decoder.decode(T.self, from: data) else { throw APIError.badDecoding }
            return response
        } catch let error {
            throw error
        }
    }

    func fetchAllLocations() async throws -> LocationResponse {
        do {
            let data = try await networkService.request(path: API.getLocations, parameters: nil)
            guard let response = try? decoder.decode(LocationResponse.self, from: data) else { throw APIError.badDecoding }
            return response
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }

    // MARK: - Private Methods
    private func makeParameters(for page: Int?) -> [String: String]? {
        if let page {
            return ["page": String(page)]
        } else {
            return nil
        }
    }
}
