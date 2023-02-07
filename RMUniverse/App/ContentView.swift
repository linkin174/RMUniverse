//
//  ContentView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import SwiftUI
import Swinject

struct ContentView: View {

    // MARK: - Wrapped Values
    @EnvironmentObject private var resolver: DependencyResolver

    // MARK: - Private Properties
    private let gridItems = [
        GridItem(.flexible(), spacing: 16, alignment: .center),
        GridItem(.flexible(), alignment: .center)
    ]

    var body: some View {
        TabView {
            CharacterListView(viewModel: CharacterListViewModel(fetcher: resolver.resolve(type: FetchingProtocol.self)))
                .tabItem {
                   Label("Characters", systemImage: "person")
                }
            LocationsView(viewModel: LocationsViewModel(fetcher: resolver.resolve(type: FetchingProtocol.self)))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DependencyResolver())
    }
}
