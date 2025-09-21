//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI
import Resolver
import BluetoothServiceInterface

enum ChatScreenAssembly {

    @MainActor
    static func assemble() -> some View {
        let state = ChatScreenViewState()
        let blueService = Resolver.resolve(AnyBluetoothService.self)
        let viewModel = ChatScreenViewModel(state: state, blueService: blueService)

        return ChatScreenView(state: state, output: viewModel)
    }
}
