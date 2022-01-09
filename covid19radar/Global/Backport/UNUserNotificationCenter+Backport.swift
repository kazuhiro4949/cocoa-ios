//
//  UNUserNotificationCenter+Backport.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/02.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    var backport: Backport<UNUserNotificationCenter> { Backport(value: self) }
}

extension Backport where T == UNUserNotificationCenter {
    func add(_ request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            value.add(request) { error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            value.requestAuthorization(
                options: options) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    continuation.resume(returning: result)
                }
        }
    }
    
    func getNotificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation({ continuation in
            value.getNotificationSettings { notificationSettings in
                continuation.resume(returning: notificationSettings)
            }
        })
    }
}
