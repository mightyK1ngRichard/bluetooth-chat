//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

@Observable
final class Router<Route: Hashable> {

    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }
}
