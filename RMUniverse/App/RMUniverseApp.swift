//
//  RMUniverseApp.swift
//  RMUniverse
//
//  Created by Aleksandr Kretov on 03.02.2023.
//

import SwiftUI
import Swinject

@main
struct RMUniverseApp: App {

    private let resolver = DependencyResolver()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resolver)
        }
    }
}

final class DependencyResolver: ObservableObject {

    func resolve<T>(type: T.Type) -> T? {
        container.resolve(type.self)
    }

    private let container: Container = {
        let container = Container()
        container.register(NetworkingProtocol.self) { _ in
            NetworkService()
        }
        container.register(FetchingProtocol.self) { resolver in
            FetcherService(networkService: resolver.resolve(NetworkingProtocol.self))
        }
        return container
    }()
}
