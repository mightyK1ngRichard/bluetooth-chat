//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

@main
struct NearbyChatApp: App {

    let coordinator = ConnectionCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigatableView(coordinator: coordinator)
        }
    }
}
