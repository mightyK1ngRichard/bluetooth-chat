//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI
import Coordinator

@main
struct NearbyChatApp: App {

    let coordinator: ConnectionCoordinator

    init() {
        DependencyRegistry.registerAll()
        coordinator = ConnectionCoordinator()
    }

    var body: some Scene {
        WindowGroup {
            NavigatableView(coordinator: coordinator)
                .preferredColorScheme(.light)
        }
    }
}
