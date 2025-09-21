//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Combine
import Foundation

final class StartScreenViewModel: Sendable {

    private let state: StartScreenViewState
    private let blueService: BluetoothService

    @MainActor
    private var cancellables: Set<AnyCancellable> = []
    @MainActor
    private weak var output: StartScreenViewModelOutput?

    private let logger = MRKLogger("Start View Model")

    @MainActor
    init(
        state: StartScreenViewState,
        blueService: BluetoothService,
        output: StartScreenViewModelOutput
    ) {
        self.state = state
        self.blueService = blueService
        self.output = output

        blueService.peersPublisher
            .receive(on: RunLoop.main)
            .sink { peer in
                switch peer.status {
                case .connected:
                    guard !state.peers.contains(peer) else { return }
                    state.peers.append(peer)
                case .disconnected:
                    state.peers.removeAll(where: { $0.peer == peer.peer })
                }
            }
            .store(in: &cancellables)

        blueService.invitationPublisher
            .receive(on: RunLoop.main)
            .sink { object in
                state.alert = .init(
                    title: "Приглашение",
                    subtitle: "Пользоваетель \(object.0.displayName) приглашает Вас в чат. Хотите вступить?",
                    buttonText: "Вступить",
                    actionOk: {
                        state.showAlert = false
                        object.1(true)
                    },
                    actionCancel: {
                        state.showAlert = false
                        object.1(false)
                    }
                )
                state.showAlert = true
            }
            .store(in: &cancellables)

        blueService.changeStatePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                switch state {
                case .connected:
                    output.startScreenDidOpenChatScreen()
                case .connecting:
                    break
                case .notConnected:
                    break
                @unknown default:
                    fatalError("Неизвестный статус")
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Output

@MainActor
extension StartScreenViewModel {

    func onTapStart() {
        logger.logEvent()
        blueService.start(roomName: "kingroom")
    }

    func onTapStop() {
        logger.logEvent()
        blueService.stop()
        state.peers.removeAll()
    }

    func onTapPeerCell(with peer: Peer) {
        logger.logEvent()
        blueService.connect(to: peer.peer)
    }
}
