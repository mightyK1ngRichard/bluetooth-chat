//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class StartScreenViewState {

    var peers: [Peer] = []
    var alert = AlertModel()
    var showAlert: Bool = false
}

struct AlertModel {

    let title: String
    let subtitle: String
    let buttonText: String
    let actionOk: () -> Void
    let actionCancel: () -> Void

    init(
        title: String = "",
        subtitle: String = "",
        buttonText: String = "",
        actionOk: @escaping () -> Void = {},
        actionCancel: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
        self.actionOk = actionOk
        self.actionCancel = actionCancel
    }
}
