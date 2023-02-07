//
//  FetcherService.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation
import Swinject

protocol FetchingProtocol {
    func getAllCharacters() async throws -> CharacterResponse
    func fetchCharacters(for characterURLs: [String]) async throws -> [Character]
    func loadNextPage<T: Codable>(url: String, type: T.Type) async throws -> T
    func fetchAllLocations() async throws -> LocationResponse
}

final class FetcherService: FetchingProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkingProtocol?

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Initializers
    init(networkService: NetworkingProtocol?) {
        self.networkService = networkService
    }

    // MARK: - Public Methods

    func getAllCharacters() async throws -> CharacterResponse {
        do {
            guard let data = try await networkService?.request(path: API.getCharacters, parameters: nil) else { throw APIError.noData }
            guard let response = try? decoder.decode(CharacterResponse.self, from: data) else { throw APIError.badDecoding }
            return response
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }

    func fetchCharacters(for characterURLs: [String]) async throws -> [Character] {
        var characters = [Character]()
        for url in characterURLs {
            guard let url = URL(string: url) else { return [] }
            do {
                guard let data = try await networkService?.request(from: url) else { throw APIError.noData }
                let character = try decoder.decode(Character.self, from: data)
                characters.append(character)
            } catch let error {
                throw error
            }
        }
        return characters
    }

    func loadNextPage<T: Codable>(url: String, type: T.Type) async throws -> T {
        do {
            guard let url = URL(string: url) else { throw APIError.badURL }
            guard let data = try await networkService?.request(from: url) else { throw APIError.noData }
            guard let response = try? decoder.decode(T.self, from: data) else { throw APIError.badDecoding }
            return response
        } catch let error {
            throw error
        }
    }

    func fetchAllLocations() async throws -> LocationResponse {
        do {
            guard let data = try await networkService?.request(path: API.getLocations, parameters: nil) else { throw APIError.noData }
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
