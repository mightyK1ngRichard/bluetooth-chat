//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public struct Peer: Identifiable, Hashable {

    public let peer: MCPeerID
    public let status: Status

    public init(peer: MCPeerID, status: Status) {
        self.peer = peer
        self.status = status
    }

    public var id: String {
        peer.displayName
    }
}

// MARK: - Status

extension Peer {

    public enum Status: Hashable {

        case connected
        case disconnected
    }
}
