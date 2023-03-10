//
//  LocationsView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 05.02.2023.
//

import SwiftUI

struct LocationsView: View {
    // MARK: - Wrapped Properties

    @StateObject var viewModel: LocationsViewModel

    // MARK: - Private Properties

    private let grid = [
        GridItem(.flexible(), spacing: 8, alignment: .center),
        GridItem(.flexible(), alignment: .center)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 8) {
                    ForEach(viewModel.locations.sorted(by: { $0.id < $1.id })) { location in
                        NavigationLink {
                            LocationView(viewModel: viewModel, location: location)
                        } label: {
                            LocationsCellView(location: location)
                                .onAppear {
                                    let maxID = viewModel.locations.map { $0.id }.max()
                                    if location.id == maxID {
                                        viewModel.fetchLocations()
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Locations")
            .padding(8)
            .background(
                Image("mainBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.2)
                    .blur(radius: 5)
            )
            .task {
                viewModel.fetchLocations()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct LocationsCellView: View {
    let location: Location

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 50)
                .cornerRadius(16)
                .shadow(color: .green.opacity(0.2), radius: 5)
            Text(location.name)
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.white)
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(viewModel: LocationsViewModel(fetcher: FetcherService(networkService: NetworkService())))
    }
}
