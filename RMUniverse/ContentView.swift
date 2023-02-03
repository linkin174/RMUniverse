//
//  ContentView.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView(viewModel: MainViewModel(fetcher: FetcherService(networkService: NetworkService())))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
