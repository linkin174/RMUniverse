//
//  LocationView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 06.02.2023.
//

import SwiftUI

struct LocationView: View {
    @StateObject private var viewModel: LocationsViewModel
    private let location: Location

    init(viewModel: LocationsViewModel, location: Location) {
        self.location = location
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Type: " + location.type)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Dimension: " + location.dimension)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: 24, weight: .bold))
            ZStack {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(viewModel.residents) { resident in
                        CharacterCell(fullName: resident.name, imageURL: resident.image)
                    }
                }
                ProgressView()
                    .scaleEffect(2)
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .offset(y: 100)
            }
        }
        .navigationTitle(location.name)
        .preferredColorScheme(.dark)
        .task {
            viewModel.fetchResidents(for: location)
        }
        .onDisappear {
            viewModel.residents.removeAll()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("mainBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.2)
                .blur(radius: 5)
        )
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationsViewModel(fetcher: FetcherService(networkService: NetworkService())), location: Location(id: 1, name: "Earth", type: "type", dimension: "dimension", residents: ["rick", "morty"], url: "https://rickandmortyapi.com/api/location/1", created: ""))
    }
}
