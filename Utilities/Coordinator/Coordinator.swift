//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

public protocol AnyCoordinator {

    associatedtype Route: Hashable
    associatedtype ContentView: View
    associatedtype DestinationView: View

    var router: Router<Route> { get set }

    @MainActor
    @ViewBuilder
    func makeView() -> ContentView

    @MainActor
    @ViewBuilder
    func makeDestination(for route: Route) -> DestinationView
}
