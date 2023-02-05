//
//  NetworkService.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import Foundation

enum APIError: Error {
    case badURL
    case noResponse
    case badResponse
    case noData
    case badDecoding
}

final class NetworkService {
    // MARK: - Public Methods
    #warning("refactor")
    func request(path: String, parameters: [String: String]?) async throws -> Data {
        guard let url = createURL(method: path, parameters: parameters) else { throw APIError.badURL }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        let result: (data: Data, response: URLResponse)? = try? await URLSession.shared.data(for: request)
        guard let response = result?.response as? HTTPURLResponse else { throw APIError.noResponse }
        guard 200...299 ~= response.statusCode else { throw APIError.badResponse }
        guard let data = result?.data else { throw APIError.noData }
        return data
    }

    func requset(from url: URL) async throws -> Data {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        let result: (data: Data, response: URLResponse)? = try? await URLSession.shared.data(for: request)
        guard let response = result?.response as? HTTPURLResponse else { throw APIError.noResponse }
        guard 200...299 ~= response.statusCode else { throw APIError.badResponse }
        guard let data = result?.data else { throw APIError.noData }
        return data
    }

    // MARK: - Private Methods

    private func createURL(method: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = method
        if let parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }
        print("URL \(components.url)")
        return components.url
    }
}
