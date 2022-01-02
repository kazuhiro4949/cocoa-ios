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
    
    func setExposureNotificationEnabled(_ enabled: Bool) async throws {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) in
            setExposureNotificationEnabled(enabled) { error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        })
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
    
    func getTestDiagnosisKeys() async throws -> [ENTemporaryExposureKey]? {
        try await withCheckedThrowingContinuation { continuation in
            getTestDiagnosisKeys { teks, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: teks)
            }
        }
    }
    
    func getExposureWindows(summary: ENExposureDetectionSummary) async throws -> [ENExposureWindow]? {
        let progress = Box<Progress?>(nil)
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress.value = getExposureWindows(summary: summary) { windows, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: windows)
                }
            }
        } onCancel: {
            progress.value?.cancel()
        }
    }
    
    func getExposureInfo(summary: ENExposureDetectionSummary, userExplanation: String) async throws -> [ENExposureInfo]? {
        let progress = Box<Progress?>(nil)
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress.value = getExposureInfo(summary: summary, userExplanation: userExplanation) { info, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: info)
                }
            }
        } onCancel: {
            progress.value?.cancel()
        }
    }
    
    func detectExposures(configuration: ENExposureConfiguration, diagnosisKeyURLs: [URL]) async throws -> ENExposureDetectionSummary? {
        let progress = Box<Progress?>(nil)
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress.value = detectExposures(configuration: configuration, diagnosisKeyURLs: diagnosisKeyURLs) { sumarry, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    
                    continuation.resume(returning: sumarry)
                }
            }
        } onCancel: {
            progress.value?.cancel()
        }
    }
}

class Box<Wrapped> {
    var value: Wrapped
    init(_ value: Wrapped) { self.value = value }
}
