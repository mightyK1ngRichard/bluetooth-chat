//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

enum ChatScreenAssembly {

    @MainActor
    static func assemble(blueService: BluetoothService) -> some View {
        let state = ChatScreenViewState()
        let viewModel = ChatScreenViewModel(state: state, blueService: blueService)

        return ChatScreenView(state: state, output: viewModel)
    }
}
