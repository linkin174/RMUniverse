//
//  CharacterViewModel.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import SwiftUI
import Combine

final class CharacterViewModel: ObservableObject {

    let character: Character

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private var cancellables = Set<AnyCancellable>()

    @Published var episodes: [Episode] = [] 

    init(character: Character) {
        self.character = character
    }

    func fetchEpisodes() {
        character.episode.forEach { episodeURL in
            guard let url = URL(string: episodeURL) else { return }
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { throw URLError(.badURL) }
                    return data
                }
                .decode(type: Episode.self, decoder: decoder)
                .sink { _ in
                } receiveValue: { [unowned self] episode in
                    self.episodes.append(episode)
                }
                .store(in: &cancellables)
        }
    }
}
