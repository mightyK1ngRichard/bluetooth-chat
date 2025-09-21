//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import Combine
import MultipeerConnectivity
import MKRCore
import BluetoothServiceInterface

/// Сервис для работы с P2P-соединением через Bluetooth/Wi-Fi
public final class BluetoothServiceImpl: NSObject, @unchecked Sendable {

    /// Идентификация устройства в сети
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    /// Сессия для обмена данными
    private var session: MCSession?
    /// Рекламирование
    private var advertiser: MCNearbyServiceAdvertiser?
    /// Сканирование других устройств
    private var browser: MCNearbyServiceBrowser?

    /// Доступные пользователи
    private let peersSubject = PassthroughSubject<Peer, Never>()
    /// Приглашения на общение
    private let invitationSubject = PassthroughSubject<(MCPeerID, (Bool) -> Void), Never>()
    /// Изменения состояний соединения
    private let changeStateSubject = PassthroughSubject<MCSessionState, Never>()

    private var messageContinuation: AsyncStream<(peer: MCPeerID, message: String)>.Continuation?
    /// Стрим сообщений
    private var _messageStream: AsyncStream<(peer: MCPeerID, message: String)>!

    private let logger = MKRLogger("Bluetooth Service")
}

// MARK: - AnyBluetoothService

extension BluetoothServiceImpl: AnyBluetoothService {

    public var messageStream: AsyncStream<(peer: MCPeerID, message: String)> {
        _messageStream
    }

    public var peersPublisher: AnyPublisher<Peer, Never> {
        peersSubject.eraseToAnyPublisher()
    }

    public var invitationPublisher: AnyPublisher<(MCPeerID, (Bool) -> Void), Never> {
        invitationSubject.eraseToAnyPublisher()
    }

    public var changeStatePublisher: AnyPublisher<MCSessionState, Never> {
        changeStateSubject.eraseToAnyPublisher()
    }

    /// Запуск сессии
    public func start(roomName: String) {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self

        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: roomName)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()

        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: roomName)
        browser?.delegate = self
        browser?.startBrowsingForPeers()

        _messageStream = AsyncStream { continuation in
            self.messageContinuation = continuation
        }

        logger.info("Сессия Bluetooth запущена")
    }

    /// Завершение сесии
    public func stop() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session?.disconnect()

        advertiser = nil
        browser = nil
        session = nil

        messageContinuation?.finish()
        messageContinuation = nil
        _messageStream = nil

        logger.info("Сессия Bluetooth завершена")
    }

    /// Подключение к выбранному peer
    public func connect(to peerID: MCPeerID) {
        guard let session = session else { return }

        browser?.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        logger.info("Отправлено приглашение для подключения к: \(peerID.displayName)")
    }

    /// Отправка текста всем подключённым peers
    public func sendMessage(_ message: String) async throws {
        guard let session,
              !session.connectedPeers.isEmpty
        else { return }

        let data = Data(message.utf8)
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        logger.info("Отправлено сообщение: \(message)")
    }
}

// MARK: - MCSessionDelegate

extension BluetoothServiceImpl: MCSessionDelegate {

    /// Каждый раз, когда состояние подключения с конкретным peer изменяется
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        logger.info("Соединение с \(peerID.displayName) изменилось на \(String(describing: state))")
        changeStateSubject.send(state)
    }

    /// Когда peer отправил данные (Data) через `session.send(_:toPeers:with:)`
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let text = String(data: data, encoding: .utf8) else {
            logger.error("Ошибка при декодировании данных")
            return
        }

        logger.info("Получено сообщение от \(peerID.displayName): \(text)")
        messageContinuation?.yield((peerID, text))
    }

    /// Если peer открыл stream
    public func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        logger.info("Был получен стрим от \(peerID) с именем \(streamName)")
    }

    /// Когда peer начинает передачу ресурса (файла)
    public func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
    }

    /// Когда peer завершил передачу ресурса
    public func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension BluetoothServiceImpl: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        logger.info("Нас пригласили: \(peerID.displayName)")

        // Обрабатываем приглашение
        invitationSubject.send((peerID, { [session] response in
            invitationHandler(response, session)
        }))
    }
}

// MARK: - MCNearbyServiceBrowserDelegate

extension BluetoothServiceImpl: MCNearbyServiceBrowserDelegate {

    public func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer: MCPeerID,
        withDiscoveryInfo info: [String : String]?
    ) {
        logger.info("Найден peer: \(foundPeer.displayName)")
        peersSubject.send(Peer(peer: foundPeer, status: .connected))
    }

    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        logger.info("Потерян peer: \(peerID.displayName)")
        peersSubject.send(Peer(peer: peerID, status: .disconnected))
    }
}
