//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

struct NavigatableView: View {

    @State
    var router: Router<ConnectionRoute>
    let coordinator: ConnectionCoordinator

    init(coordinator: ConnectionCoordinator) {
        router = coordinator.router
        self.coordinator = coordinator
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ContentWrapperView(coordinator: coordinator)
                .equatable()
        }
    }
}

struct ContentWrapperView: View, Equatable {

    let coordinator: ConnectionCoordinator

    var body: some View {
        coordinator.makeView()
            .navigationDestination(for: ConnectionRoute.self) { route in
                coordinator.makeDestination(for: route)
            }
    }

    static func == (lhs: ContentWrapperView, rhs: ContentWrapperView) -> Bool {
        true
    }
}
