//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI
import Resolver
import BluetoothServiceInterface

enum StartAssembly {

    @MainActor
    static func assemble(output: StartScreenViewModelOutput) -> some View {
        let state = StartScreenViewState()
        let blueService = MKRResolver.resolve(AnyBluetoothService.self)
        let viewModel = StartScreenViewModel(
            state: state,
            blueService: blueService,
            output: output
        )

        return StartScreenView(state: state, output: viewModel)
    }
}
