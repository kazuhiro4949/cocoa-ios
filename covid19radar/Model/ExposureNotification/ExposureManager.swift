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
import ZIPFoundation

enum HelthCheck {
    case active
    case unauthorized
    case needsConfirm
}

class ExposureManager {
    static let exposureNotificationStatusChanged = Notification.Name.init(rawValue: "ExposureManager.exposureNotificationStatusChanged")
    
    static let shared = ExposureManager()
    
    private(set) var detectingExposures = false
    private let enManager = ENManager()
    private static let bgIdentifier = "jp.go.mhlw.covid19radar.exposure-notification"
    
    private var observers = [NSObjectProtocol]()
    
    init() {
        observers.append(enManager.observe(\.exposureNotificationStatus) { manager, changed in
            if changed.oldValue != changed.newValue {
                NotificationCenter.default.post(name: ExposureManager.exposureNotificationStatusChanged, object: self)
            }
        })
    }
    
    var helthCheck: HelthCheck {
        switch enManager.exposureNotificationStatus {
        case .active:
            return .active
        case .unauthorized:
            return .unauthorized
        default:
            return .needsConfirm
        }
    }

    func startBGTaskScheduling() {
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
    
    func detectExposures() async throws {
        guard !detectingExposures else {
            throw AppErorr.general
        }
        
        detectingExposures = true
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let detectExposureDirectory = documentDirectory.appendingPathComponent("detectExposure", isDirectory: true)
        
        defer {
            try? FileManager.default.removeItem(at: detectExposureDirectory)
            detectingExposures = false
        }
        
        let config = try await getConfig()
        let entries = try await getTargetDiagnosisEntries(region: "440")
        let localURLs = try await downloadDiagnosisKeys(entries: entries)
        
        var decomposedURLs = [URL]()
        for url in localURLs {
            let lastPathComponent = (url.lastPathComponent as NSString)
            guard lastPathComponent.pathExtension == ".zip" else {
                continue
            }
            
            let fileDir = lastPathComponent.deletingPathExtension
            let directory = detectExposureDirectory.appendingPathComponent(fileDir, isDirectory: true)
            var isDirectory: ObjCBool = true
            if FileManager.default.fileExists(atPath: directory.path, isDirectory: &isDirectory) {
                try FileManager.default.removeItem(at: directory)
            }

            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            
            try FileManager.default.unzipItem(at: url, to: directory)
            let exportBin = directory.appendingPathComponent("export.bin")
            let exportSig = directory.appendingPathComponent("export.sig")
            guard FileManager.default.fileExists(atPath: exportBin.path)
                    && FileManager.default.fileExists(atPath: exportSig.path) else {
                   throw AppErorr.general
            }
            
            decomposedURLs.append(contentsOf: [exportBin, exportSig])
        }
        
        let summary = try await enManager.detectExposures(
            configuration: try await config.convertENConfig(),
            diagnosisKeyURLs: decomposedURLs
        )
        guard let summary = summary else {
            throw AppErorr.general
        }
        
        if #available(iOS 13.7, *) {
            let windows = try await enManager.getExposureWindows(summary: summary)
            guard let windows = windows else {
                throw AppErorr.general
            }
            
            let encodedSummaries = try JSONEncoder().encode(summary.daySummaries.map(ExposureDaySummary.init))
            let encodedWindows = try JSONEncoder().encode(windows.map(ExposureWindow.init))
            UserDefaults.standard.set(encodedSummaries, forKey: "ENExposureDaySummary")
            UserDefaults.standard.set(encodedWindows, forKey: "ENExposureWindow")
        } else {
//            let info = try await enManager.getExposureInfo(summary: summary, userExplanation: "説明")
//            guard let info = info else {
//                throw AppErorr.general
//            }
            
            // TODO: - needs to append to list without duplication
//            let encodedSummaries = try JSONEncoder().encode(summary.daySummaries.map(ExposureDaySummary.init))
//            let encodedInformationList = try JSONEncoder().encode(info.map(ExposureInfo.init))
//            UserDefaults.standard.set(encodedSummaries, forKey: "ENExposureDaySummary")
//            UserDefaults.standard.set(encodedInformationList, forKey: "ENExposureInformation")
        }
        
        let dict = UserDefaults.standard.dictionary(forKey: "LastProcessTekTimestamp")
        var lastProcessTimestampList = (dict as? [String: Int64]) ?? [String: Int64]()
        lastProcessTimestampList["440"] = entries.sorted(by: { $0.created < $1.created }).last?.created
        UserDefaults.standard.set(lastProcessTimestampList, forKey: "LastProcessTekTimestamp")
        
        // TODO: - return detected Data
    }
    
    private func createBGTaskIfNeeded() {
            BGTaskScheduler.shared.register(
                forTaskWithIdentifier: type(of: self).bgIdentifier,
                using: .main
            ) { [weak self] task in
                self?.scheduleBGTaskIfNeeded()
                
                let detectionTask = Task { [weak self] in
                    guard let self = self else {
                        task.setTaskCompleted(success: false)
                        return
                    }
                    
                    do {
                        try await self.activateENManager()
                        try await self.enableENManagerIfNeeded()

                        try await self.showBluetoothOffUserNotificationIfNeeded()
                        try await self.detectExposures()
                        // TODO: - handle local notification
                        task.setTaskCompleted(success: true)
                    } catch {
                        task.setTaskCompleted(success: false)
                    }
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
    
    func getTargetDiagnosisEntries(region: String) async throws -> [DiagnosisKeyEntry] {
        let diagnosisKeyEntries = try await getDiagnosisKeyList()
        
        // refactor
        let dict = UserDefaults.standard.dictionary(forKey: "LastProcessTekTimestamp")
        let lastProcessTimestampList =  (dict as? [String: Int64])
        let targetDiagnosisKeyEntries: [DiagnosisKeyEntry]
        if let lastProcessTimestamp = lastProcessTimestampList?[region] {
            targetDiagnosisKeyEntries = diagnosisKeyEntries.filter { lastProcessTimestamp < $0.created }
        } else {
            targetDiagnosisKeyEntries = diagnosisKeyEntries
        }
        
        if targetDiagnosisKeyEntries.isEmpty {
            throw AppErorr.general
        }
        
        return targetDiagnosisKeyEntries
    }
    
    func downloadDiagnosisKeys(entries: [DiagnosisKeyEntry]) async throws -> [URL] {
        var localURLs = [URL]()
        try await withThrowingTaskGroup(of: URL.self) { [weak self] group in
            for entry in entries {
                group.addTask(priority: .background) { [weak self] in
                    guard let self = self else {
                        throw AppErorr.general
                    }
                    
                    return try await self.downloadDiagnosisKey(with: entry)
                }
            }
            
            for try await urls in group {
                localURLs.append(urls)
            }
        }
        
        return localURLs
    }
    
    private func downloadDiagnosisKey(with entry: DiagnosisKeyEntry) async throws -> URL {
        guard let url = entry.url else {
            throw AppErorr.general
        }
        
        let (data, resp) = try await URLSession.defaultApi.data(for: URLRequest(url: url)) // TODO: - needs to use download task?
        if (resp as? HTTPURLResponse)?.statusCode != 200 {
            throw AppErorr.general
        }
        
        let filename = url.lastPathComponent
        guard let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw AppErorr.general
        }
        
        let outputPath = documentDir.appendingPathComponent(filename)
        try data.write(to: outputPath)
        
        return outputPath
    }
    
    private func getDiagnosisKeyList() async throws -> [DiagnosisKeyEntry] {
        let (data, _) = try await URLSession.defaultApi.data(for: .makeGetDiagnosisKeyList())
        return try JSONDecoder().decode([DiagnosisKeyEntry].self, from: data)
    }
    
    private func getConfig() async throws -> ExposureConfig {
        guard let downloadedConfigObject = UserDefaults.standard.data(forKey: "ExposureConfigurationDownloaded"),
              let downloadedDate = UserDefaults.standard.object(forKey: "ExposureConfigurationDownloadedDate") as? Date,
              let updatableDate = Calendar.current.date(byAdding: .day, value: 2, to: downloadedDate) else {
            throw AppErorr.general
        }
        
        let downloadedConfig = try JSONDecoder().decode(ExposureConfig.self, from: downloadedConfigObject)
        if Date() <= updatableDate {
            return downloadedConfig
        }
        
        let (data, _) = try await URLSession.shared.data(for: .makeGetConfiguration())
        let config = try JSONDecoder().decode(ExposureConfig.self, from: data)
        UserDefaults.standard.set(Date(), forKey: "ExposureConfigurationDownloadedDate")
        
        let nextExposureConfig: ExposureConfig
        if downloadedConfig.appleExposureConfigV2 != config.appleExposureConfigV2,
            let appliedDate = UserDefaults.standard.object(forKey: "ExposureConfigurationAppliedDate") as? Date,
            let expirationDate = Calendar.current.date(byAdding: .day, value: 7 + 1, to: appliedDate),
            expirationDate <= Date() {

            nextExposureConfig = config
            UserDefaults.standard.set(Date(), forKey: "ExposureConfigurationAppliedDate")
        } else {
            nextExposureConfig = downloadedConfig
        }
        
        UserDefaults.standard.set(data, forKey: "ExposureConfigurationDownloaded")
        return nextExposureConfig
    }
    
    deinit {
        enManager.invalidate()
    }
}

// for persistant
struct ExposureWindow: Codable {
    let calibrationConfidence: UInt8
    let date: Date
    let diagnosisReportType: UInt32
    let infectiousness: UInt32
    let scanInstances: [ScanInstance]
    
    init(_ window: ENExposureWindow) {
        calibrationConfidence = window.calibrationConfidence.rawValue
        date = window.date
        diagnosisReportType = window.diagnosisReportType.rawValue
        infectiousness = window.infectiousness.rawValue
        scanInstances = window.scanInstances.map(ScanInstance.init)
    }
}

struct ScanInstance : Codable {
    let minimumAttenuation: UInt8
    let typicalAttenuation: UInt8
    let secondsSinceLastScan: Int
    
    init(_ scanInstance: ENScanInstance) {
        minimumAttenuation = scanInstance.minimumAttenuation
        typicalAttenuation = scanInstance.typicalAttenuation
        secondsSinceLastScan = scanInstance.secondsSinceLastScan
    }
}

struct ExposureDaySummary: Codable {
    let date: Date
    let confirmedTestSummary: ExposureSummaryItem?
    let confirmedClinicalDiagnosisSummary: ExposureSummaryItem?
    let recursiveSummary: ExposureSummaryItem?
    let selfReportedSummary: ExposureSummaryItem?
    let daySummary: ExposureSummaryItem
    
    init(_ summary: ENExposureDaySummary) {
        date = summary.date
        confirmedTestSummary = summary.confirmedTestSummary.flatMap(ExposureSummaryItem.init)
        confirmedClinicalDiagnosisSummary = summary.confirmedClinicalDiagnosisSummary.flatMap(ExposureSummaryItem.init)
        recursiveSummary = summary.recursiveSummary.flatMap(ExposureSummaryItem.init)
        selfReportedSummary = summary.selfReportedSummary.flatMap(ExposureSummaryItem.init)
        daySummary = ExposureSummaryItem(summary.daySummary)
    }
}

struct ExposureSummaryItem : Codable {
    let maximumScore: Double
    let scoreSum: Double
    let weightedDurationSum: TimeInterval
    
    init(_ item: ENExposureSummaryItem) {
        maximumScore = item.maximumScore
        scoreSum = item.scoreSum
        weightedDurationSum = item.weightedDurationSum
    }
}

// V1 detected entity
struct ExposureInfo: Codable {
    let attenuationDurations: [Int]
    let attenuationValue: UInt8
    let date: Date
    let totalRiskScore: UInt8
    let transmissionRiskLevel: UInt8
    
    init(_ info: ENExposureInfo) {
        attenuationDurations = info.attenuationDurations.map { $0.intValue }
        attenuationValue = info.attenuationValue
        date = info.date
        totalRiskScore = info.totalRiskScore
        transmissionRiskLevel = info.transmissionRiskLevel
    }
}
