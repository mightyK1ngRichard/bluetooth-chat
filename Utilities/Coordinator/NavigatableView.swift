//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

public struct NavigatableView<C: AnyCoordinator>: View {

    @State
    private var router: Router<C.Route>
    private let coordinator: C

    public init(coordinator: C) {
        router = coordinator.router
        self.coordinator = coordinator
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            ContentWrapperView(coordinator: coordinator)
                .equatable()
        }
    }
}

// MARK: - ContentWrapperView

struct ContentWrapperView<C: AnyCoordinator>: View, Equatable {

    let coordinator: C

    var body: some View {
        coordinator.makeView()
            .navigationDestination(for: C.Route.self) { route in
                coordinator.makeDestination(for: route)
            }
    }

    static func == (lhs: ContentWrapperView, rhs: ContentWrapperView) -> Bool {
        true
    }
}
