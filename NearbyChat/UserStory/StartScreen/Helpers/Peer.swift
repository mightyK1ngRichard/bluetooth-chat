//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct Peer: Identifiable, Hashable {

    let peer: MCPeerID
    let status: Status

    var id: String {
        peer.displayName
    }
}

// MARK: - Status

extension Peer {

    enum Status {

        case connected
        case disconnected
    }
}
