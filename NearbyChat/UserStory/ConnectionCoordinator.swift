//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

final class ConnectionCoordinator {

    let router = Router<ConnectionRoute>()
    let blueService = BluetoothService()
    private let logger = MRKLogger("Connection Coordinator")

    @MainActor
    @ViewBuilder
    func makeView() -> some View {
        makeDestination(for: .start)
    }

    @MainActor
    @ViewBuilder
    func makeDestination(for route: ConnectionRoute) -> some View {
        switch route {
        case .start:
            StartAssembly.assemble(blueService: blueService, output: self)
        case .chat:
            ChatScreenAssembly.assemble(blueService: blueService)
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
