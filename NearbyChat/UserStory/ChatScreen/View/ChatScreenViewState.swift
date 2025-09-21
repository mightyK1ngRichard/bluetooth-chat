//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

@MainActor
@Observable
final class ChatScreenViewState: Sendable {

    var inputText: String = ""
    var messages: [Message] = []
}

// MARK: - Message

extension ChatScreenViewState {

    struct Message: Identifiable, Hashable {

        let id = UUID()
        let author: String
        let text: String
        let isYou: Bool
    }
}
