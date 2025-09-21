//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import BluetoothServiceInterface

public enum BluetoothServiceAssembly {

    public static func assemble() -> AnyBluetoothService {
        BluetoothServiceImpl()
    }
}
