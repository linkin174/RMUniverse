//
//  MainView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import SwiftUI

struct MainView: View {

    // MARK: - Private Properties

    @StateObject private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        Text("ss")
            .task {
                viewModel.fetchCharacters()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(fetcher: FetcherService(networkService: NetworkService())))
    }
}
