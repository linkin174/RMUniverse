//
//  MainView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import SwiftUI

struct MainView: View {
    // MARK: - Wrapped Values
    @StateObject private var viewModel: MainViewModel

    // MARK: - Private Properties
    private let gridItems = [
        GridItem(.flexible(), spacing: 16, alignment: .center),
        GridItem(.flexible(), alignment: .center)
    ]


    init(viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        TabView {
            CharactersView(viewModel: CharactersListViewModel(fetcher: FetcherService(networkService: NetworkService())))
            .tabItem {
                Text("Characters")
            }

           LocationsView(viewModel: LocationsViewModel(fetcher: FetcherService(networkService: NetworkService())))
                .tabItem {
                    Text("Locations")
                }
            Text("Episodes here")
                .tabItem {
                    Text("Episodes")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static let viewModel = MainViewModel(fetcher: FetcherService(networkService: NetworkService()))
    static var previews: some View {
        MainView(viewModel: viewModel)
    }
}
