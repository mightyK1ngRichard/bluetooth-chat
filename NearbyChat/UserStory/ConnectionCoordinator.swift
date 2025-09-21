//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI
import MKRCore
import BluetoothServiceInterface
import Coordinator

final class ConnectionCoordinator: AnyCoordinator {

    var router: Router<ConnectionRoute>
    private let logger = MKRLogger("Connection Coordinator")

    init(router: Router<ConnectionRoute> = .init()) {
        self.router = router
    }

    func makeView() -> some View {
        makeDestination(for: .start)
    }

    func makeDestination(for route: ConnectionRoute) -> some View {
        switch route {
        case .start:
            StartAssembly.assemble(output: self)
        case .chat:
            ChatScreenAssembly.assemble()
        }
    }
}

// MARK: - StartScreenViewModelOutput

extension ConnectionCoordinator: StartScreenViewModelOutput {

    func startScreenDidOpenChatScreen() {
        logger.logEvent()
        router.push(.chat)
    }
}
