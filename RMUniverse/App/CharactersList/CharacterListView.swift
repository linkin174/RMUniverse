//
//  CharactersView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import SwiftUI

struct CharacterListView: View {
    // MARK: - Wrapped Values
    @StateObject var viewModel: CharacterListViewModel
    @State private var searchString = ""

    private let gridItems = [
        GridItem(.flexible(), spacing: 16, alignment: .center),
        GridItem(.flexible(), alignment: .center)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 8) {
                    ForEach(viewModel.characters) { character in
                        NavigationLink(destination: CharacterView(viewModel: CharacterViewModel(character: character))) {
                            CharacterCell(fullName: character.name, imageURL: character.image)
                                .onAppear {
                                    #warning("reslove search")
                                    var maxID = 0
                                    if viewModel.isSearching {
                                        maxID = viewModel.searchResults.map { $0.id }.max() ?? 0
                                    } else {
                                       maxID = viewModel.characters.map { $0.id }.max() ?? 0
                                    }
                                    if character.id == maxID {
                                        viewModel.fetchCharacters()
                                    }
                                }
                        }
                        
                    }
                }
            }
            .onChange(of: searchString) { newValue in
                viewModel.searchCharacters(request: newValue)
            }
            .navigationTitle("Characters")
            .task {
                viewModel.fetchCharacters()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextField("Search characters", text: $searchString)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(16)
                }

            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel(fetcher: FetcherService(networkService: NetworkService())))
    }
}
