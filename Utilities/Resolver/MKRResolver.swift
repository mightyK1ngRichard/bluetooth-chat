//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation

public final class MKRResolver: Sendable {

    private enum Registration {
        case factory(() -> Any)
        case singleton(() -> Any)
    }

    private static var services: [String: Registration] = [:]
    private static var cachedSingletons: [String: Any] = [:]

    public static func register<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        let key = "\(type)"
        services[key] = .factory({ factory() })
    }

    public static func registerSingleton<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        let key = "\(type)"
        services[key] = .singleton({ factory() })
    }

    public static func resolve<T>(_ type: T.Type) -> T {
        let key = "\(type)"
        guard let registration = services[key] else {
            fatalError("Service for type \(type) not registered!")
        }

        switch registration {
        case .factory(let factory):
            guard let instance = factory() as? T else {
                fatalError("Registered factory for type \(type) returned wrong type")
            }
            return instance
        case .singleton(let factory):
            if let cached = cachedSingletons[key] as? T {
                return cached
            }
            guard let instance = factory() as? T else {
                fatalError("Registered singleton factory for type \(type) returned wrong type")
            }
            cachedSingletons[key] = instance
            return instance
        }
    }
}
