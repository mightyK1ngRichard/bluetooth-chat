//
//  Created by Dmitriy Permyakov on 21.09.2025.
//  Copyright © 2025 MightyKingRichard. All rights reserved.
//

import Foundation
import os

public final class MKRLogger: Sendable {

    private let name: String

    public init(_ name: String) {
        self.name = name
    }

    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    public func logEvent(file: String = #file, function: String = #function, line: Int = #line) {
        log(function, level: .info, file: file, function: function, line: line)
    }

    private func log(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let logMessage = "\(timestamp) [\(level.rawValue)] [\(name)] \(message)"

        print(logMessage)
    }
}

// MARK: - LogLevel

extension MKRLogger {

    enum LogLevel: String {

        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
}
