//
//  CharacterView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import SwiftUI

struct CharacterView: View {
    @StateObject private var viewModel: CharacterViewModel

    init(viewModel: CharacterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            CachedAsyncImage(url: URL(string: viewModel.character.image)!, transaction: .init(animation: .easeOut)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .scaledToFit()
            }
            Group {
                Text("Gender: " + viewModel.character.gender)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Status: " + viewModel.character.status)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Species: " + viewModel.character.species)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Origin: " + viewModel.character.origin.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Location: " + viewModel.character.location.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 8)
            Section {
                ForEach(viewModel.episodes.sorted(by: { $0.id < $1.id })) { episode in
                    EpisodeCellView(episode: episode)
                        .frame(height: 100)
                        .cornerRadius(16)
                        .shadow(color: .green.opacity(0.5), radius: 10)
                        .redacted(reason: viewModel.episodes.isEmpty ? .placeholder : [])
                }
                .padding(.horizontal, 8)
            } header: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.orange)
                        .frame(height: 30)
                    Text("Episodes")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                }
            }
        }
        .preferredColorScheme(.dark)
        .background(
            Image("mainBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.2)
                .blur(radius: 5)
        )
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.character.name)
        .onAppear {
            viewModel.fetchEpisodes()
        }
    }
}

struct EpisodeCellView: View {
    let episode: Episode
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .shadow(color: .pink, radius: 10, x: 1, y: 1)
            HStack {
                Spacer()
                ZStack {
                    Image("cellBG")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            LinearGradient(colors: [.black, .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 0))
                        }
                }
            }
            VStack {
                Text(episode.name)
                    .font(.system(size: 22, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Release: " + episode.airDate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Season: \(getSeasonAndEpisodeNumbers(from: episode).seasone)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 13))
                Text("Episode: \(getSeasonAndEpisodeNumbers(from: episode).episode)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 13))
            }
            .padding(.leading, 8)
            .foregroundColor(.white)
        }
        .clipped()
        .shadow(color: .pink, radius: 10, x: 1, y: 1)
    }

    private func getSeasonAndEpisodeNumbers(from episode: Episode) -> (seasone: String, episode: String) {
        let episode = episode.episode
        let seasonStartIndex = episode.index(episode.startIndex, offsetBy: 1)
        let seasonEndIndex = episode.index(seasonStartIndex, offsetBy: 2)
        let seasonSub = episode[seasonStartIndex..<seasonEndIndex]
        let episodeStartIndex = episode.index(seasonEndIndex, offsetBy: 1)
        let episodeSub = episode[episodeStartIndex..<episode.endIndex]
        return (String(seasonSub), String(episodeSub))
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CharacterView(viewModel: CharacterViewModel(character: Character.placeholder))
                .navigationTitle("Rick")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
