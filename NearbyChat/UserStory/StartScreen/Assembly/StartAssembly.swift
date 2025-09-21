//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

enum StartAssembly {

    @MainActor
    static func assemble(blueService: BluetoothService, output: StartScreenViewModelOutput) -> some View {
        let state = StartScreenViewState()
        let viewModel = StartScreenViewModel(
            state: state,
            blueService: blueService,
            output: output
        )

        return StartScreenView(state: state, output: viewModel)
    }
}
