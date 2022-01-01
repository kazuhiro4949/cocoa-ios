//
//  ENManager+Backport.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation
import ExposureNotification

@available(iOS, deprecated: 15.0)
extension ENManager {
    func activate() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            activate { error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
    
    func getDiagnosisKeys() async throws -> [ENTemporaryExposureKey]? {
        try await withCheckedThrowingContinuation { continuation in
            getDiagnosisKeys { teks, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: teks)
            }
        }
    }
}
