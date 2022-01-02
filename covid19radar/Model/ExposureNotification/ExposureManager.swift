//
//  ExposureManager.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation
import ExposureNotification
import BackgroundTasks
import UserNotifications

class ExposureManager {
    static let shared = ExposureManager()
    
    private(set) var detectingExposures = false
    private let enManager = ENManager()
    private static let bgIdentifier = Bundle.main.bundleIdentifier! + ".exposure-notification"

    init() {
        createBGTaskIfNeeded()
        scheduleBGTaskIfNeeded()
    }
    
    
    /// Needs to call every launching
    func activateENManager() async throws {
        try await enManager.activate()
    }
    
    func enableENManagerIfNeeded() async throws {
        if !enManager.exposureNotificationEnabled {
            try await enManager.setExposureNotificationEnabled(true)
        }
    }
    
    func getDiagnosisKeys() async throws -> [ENTemporaryExposureKey]? {
        try await enManager.getDiagnosisKeys()
    }
    
    func detectExposures() async -> Bool {
        guard !detectingExposures else {
            return false
        }
        
        detectingExposures = true
        defer {
            detectingExposures = false
        }
        
        let nextDiagnosisKeyFileIndex = LocalStore.shared.nextDiagnosisKeyFileIndex
        do {
            let remoteURLs = try await getDiagnosisKeyFileURLs(startingAt: nextDiagnosisKeyFileIndex)
            
            var localURLs = [URL]()
            try await withThrowingTaskGroup(of: [URL].self) { group in
                for remoteURL in remoteURLs {
                    group.addTask(priority: .background) {
                        return try await self.downloadDiagnosisKeyFile(at: remoteURL)
                    }
                }
                
                for try await urls in group {
                    localURLs.append(contentsOf: urls)
                }
            }
            
            let config = try await ExposureConfiguration.mock.convertENConfig() // TODO: - fix
            let summary = try await enManager.detectExposures(configuration: config, diagnosisKeyURLs: localURLs)
            guard let summary = summary else {
                throw AppErorr.general
            }
            
            let result: ([Exposure], Int)
            if #available(iOS 13.7, *) {
                let windows = try await enManager.getExposureWindows(summary: summary)
                guard let windows = windows else {
                    throw AppErorr.general
                }
                
                let exposures = windows.map { Exposure(date: $0.date) }
                result = (exposures, nextDiagnosisKeyFileIndex + localURLs.count)
            } else {
                let info = try await enManager.getExposureInfo(summary: summary, userExplanation: "説明")
                guard let info = info else {
                    throw AppErorr.general
                }
                
                let exposures = info.map { Exposure(date: $0.date) }
                result = (exposures, nextDiagnosisKeyFileIndex + localURLs.count)
            }
            
            LocalStore.shared.nextDiagnosisKeyFileIndex = nextDiagnosisKeyFileIndex
            // Starting with the V2 API, ENManager will return cached results, so replace our saved results instead of appending
            if #available(iOS 13.7, *) {
                LocalStore.shared.exposures = result.0
            } else {
                LocalStore.shared.exposures.append(contentsOf: result.0)
            }
            LocalStore.shared.exposures.sort { $0.date < $1.date }
            LocalStore.shared.dateLastPerformedExposureDetection = Date()
            LocalStore.shared.exposureDetectionErrorLocalizedDescription = nil
            
            return true
        } catch {
            LocalStore.shared.exposureDetectionErrorLocalizedDescription = error.localizedDescription
            return false
        }
    }
    
    private func createBGTaskIfNeeded() {
            BGTaskScheduler.shared.register(
                forTaskWithIdentifier: type(of: self).bgIdentifier,
                using: .main
            ) { [weak self] task in
                self?.scheduleBGTaskIfNeeded()
                
                let detectionTask = Task { [weak self] in
                    // TODO: - ERROR HANDLING
                    try? await self?.activateENManager()
                    try? await self?.enableENManagerIfNeeded()

                    try? await self?.showBluetoothOffUserNotificationIfNeeded()
                    let isSuccess = (await self?.detectExposures()) ?? false
                    task.setTaskCompleted(success: isSuccess)
                }
                
                task.expirationHandler = {
                    detectionTask.cancel()
                    LocalStore.shared.exposureDetectionErrorLocalizedDescription = "timeout"
                }
            }
    }
    
    private func scheduleBGTaskIfNeeded() {
        guard ENManager.authorizationStatus == .authorized else { return }
        let taskRequest = BGProcessingTaskRequest(identifier: ExposureManager.bgIdentifier)
        taskRequest.requiresNetworkConnectivity = true
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            print("Unable to schedule background task: \(error)")
        }
    }
    
    private func showBluetoothOffUserNotificationIfNeeded() async throws {
        let identifier = "bluetooth-off"
        if ENManager.authorizationStatus == .authorized
            && enManager.exposureNotificationStatus == .bluetoothOff {
            
            let content = UNMutableNotificationContent()
            content.title = "Bluetoothがオフです"
            content.body = "設定アプリを開いてBluetoothをオンにしてください"
            content.sound = .default
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: nil
            )
            try await UNUserNotificationCenter.current().add(request)
        } else {
            UNUserNotificationCenter.current()
                .removeDeliveredNotifications(withIdentifiers: [identifier])
        }
    }
    
    private func getDiagnosisKeyFileURLs(startingAt index: Int) async throws -> [URL] {
        let remoteURLs = [URL(string: "/url/to/export\(index)")!]
        return Array(remoteURLs[min(index, remoteURLs.count)...])
    }
    
    func downloadDiagnosisKeyFile(at remoteURL: URL) async throws -> [URL] {
        return []
    }
    
    deinit {
        enManager.invalidate()
    }
}
