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
        var progress: Progress?
        let onCancel = { progress?.cancel() }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress = getExposureWindows(summary: summary) { windows, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: windows)
                }
            }
        } onCancel: {
            onCancel()
        }
    }
    
    func getExposureInfo(summary: ENExposureDetectionSummary, userExplanation: String) async throws -> [ENExposureInfo]? {
        var progress: Progress?
        let onCancel = { progress?.cancel() }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress = getExposureInfo(summary: summary, userExplanation: userExplanation) { info, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: info)
                }
            }
        } onCancel: {
            onCancel()
        }
    }
    
    func detectExposures(configuration: ENExposureConfiguration, diagnosisKeyURLs: [URL]) async throws -> ENExposureDetectionSummary? {
        var progress: Progress?
        let onCancel = { progress?.cancel() }
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                progress = detectExposures(configuration: configuration, diagnosisKeyURLs: diagnosisKeyURLs) { sumarry, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    
                    continuation.resume(returning: sumarry)
                }
            }
        } onCancel: {
            onCancel()
        }
    }
}
