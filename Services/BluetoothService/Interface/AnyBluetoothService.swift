//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import Combine
import MultipeerConnectivity

public protocol AnyBluetoothService: Sendable {

    /// Запуск сессии
    func start(roomName: String)
    /// Завершение сесии
    func stop()
    /// Подключение к выбранному peer
    func connect(to peerID: MCPeerID)
    /// Отправка текста всем подключённым peers
    func sendMessage(_ message: String) async throws

    /// Доступные пользователи
    var peersPublisher: AnyPublisher<Peer, Never> { get }
    /// Приглашения на общение
    var invitationPublisher: AnyPublisher<(MCPeerID, (Bool) -> Void), Never> { get }
    /// Изменения состояний соединения
    var changeStatePublisher: AnyPublisher<MCSessionState, Never> { get }
    /// Сообщения
    var messageStream: AsyncStream<(peer: MCPeerID, message: String)> { get }
}
