//
//  UNUserNotificationCenter+Backport.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/02.
//

import Foundation
import UserNotifications

@available(iOS, deprecated: 15.0)
extension UNUserNotificationCenter {
    func add(_ request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            add(request) { error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
}
