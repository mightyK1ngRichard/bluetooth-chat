//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import SwiftUI

extension View {

    public func onFirstAppear(perform onFirstAppearAction: @escaping () -> () ) -> some View {
        modifier(OnFirstAppearModifier(onFirstAppearAction))
    }
}

// MARK: - OnFirstAppearModifier

private struct OnFirstAppearModifier: ViewModifier {

    private let onFirstAppearAction: () -> Void

    @State
    private var hasAppeared = false

    public init(_ onFirstAppearAction: @escaping () -> ()) {
        self.onFirstAppearAction = onFirstAppearAction
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                onFirstAppearAction()
            }
    }
}
