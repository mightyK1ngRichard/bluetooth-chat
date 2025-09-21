//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import MKRCore
import BluetoothServiceInterface

final class ChatScreenViewModel: Sendable {

    private let state: ChatScreenViewState
    private let blueService: AnyBluetoothService
    private let logger = MKRLogger("Chat View Model")

    init(state: ChatScreenViewState, blueService: AnyBluetoothService) {
        self.state = state
        self.blueService = blueService
    }
}

// MARK: - ChatScreenViewOutput

@MainActor
extension ChatScreenViewModel {

    func onDisappear() {
        logger.logEvent()
        blueService.stop()
    }

    func onFirstAppear() {
        logger.logEvent()

        Task {
            for await message in blueService.messageStream {
                state.messages.append(.init(author: message.peer.displayName, text: message.message, isYou: false))
            }
        }
    }

    func onTapSendMessage() {
        logger.logEvent()
        guard !state.inputText.isEmpty else { return }

        let message = state.inputText
        state.messages.append(.init(author: "Вы", text: message, isYou: true))
        state.inputText = String()

        Task {
            do {
                try await blueService.sendMessage(message)
            } catch {
                logger.error("Ошибка при отправке сообщения: \(error)")
            }
        }
    }
}
