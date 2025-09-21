//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import Resolver
import BluetoothServiceInterface
import BluetoothService

public enum DependencyRegistry {

    public static func registerAll() {
        Resolver.registerSingleton(AnyBluetoothService.self) {
            BluetoothServiceImpl()
        }
    }
}
