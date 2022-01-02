//
//  ExposureConfiguration.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/02.
//

import Foundation
import ExposureNotification

struct ExposureConfiguration: Codable {
    // API V2 Keys
    let immediateDurationWeight: Double
    let nearDurationWeight: Double
    let mediumDurationWeight: Double
    let otherDurationWeight: Double
    let infectiousnessForDaysSinceOnsetOfSymptoms: [String: Int]
    let infectiousnessStandardWeight: Double
    let infectiousnessHighWeight: Double
    let reportTypeConfirmedTestWeight: Double
    let reportTypeConfirmedClinicalDiagnosisWeight: Double
    let reportTypeSelfReportedWeight: Double
    let reportTypeRecursiveWeight: Double
    let reportTypeNoneMap: Int
    // API V1 Keys
    let minimumRiskScore: ENRiskScore
    let attenuationDurationThresholds: [Int]
    let attenuationLevelValues: [ENRiskLevelValue]
    let daysSinceLastExposureLevelValues: [ENRiskLevelValue]
    let durationLevelValues: [ENRiskLevelValue]
    let transmissionRiskLevelValues: [ENRiskLevelValue]
    
    
    func convertENConfig() async throws -> ENExposureConfiguration {
        let exposureConfiguration = ENExposureConfiguration()
        exposureConfiguration.immediateDurationWeight = immediateDurationWeight
        exposureConfiguration.nearDurationWeight = nearDurationWeight
        exposureConfiguration.mediumDurationWeight = mediumDurationWeight
        exposureConfiguration.otherDurationWeight = otherDurationWeight
        var infectiousnessForDaysSinceOnsetOfSymptoms = [Int: Int]()
        for (stringDay, infectiousness) in self.infectiousnessForDaysSinceOnsetOfSymptoms {
            if stringDay == "unknown" {
                if #available(iOS 14.0, *) {
                    infectiousnessForDaysSinceOnsetOfSymptoms[ENDaysSinceOnsetOfSymptomsUnknown] = infectiousness
                } else {
                    // ENDaysSinceOnsetOfSymptomsUnknown is not available
                    // in earlier versions of iOS; use an equivalent value
                    infectiousnessForDaysSinceOnsetOfSymptoms[NSIntegerMax] = infectiousness
                }
            } else if let day = Int(stringDay) {
                infectiousnessForDaysSinceOnsetOfSymptoms[day] = infectiousness
            }
        }
        exposureConfiguration.infectiousnessForDaysSinceOnsetOfSymptoms = infectiousnessForDaysSinceOnsetOfSymptoms as [NSNumber: NSNumber]
        exposureConfiguration.infectiousnessStandardWeight = infectiousnessStandardWeight
        exposureConfiguration.infectiousnessHighWeight = infectiousnessHighWeight
        exposureConfiguration.reportTypeConfirmedTestWeight = reportTypeConfirmedTestWeight
        exposureConfiguration.reportTypeConfirmedClinicalDiagnosisWeight = reportTypeConfirmedClinicalDiagnosisWeight
        exposureConfiguration.reportTypeSelfReportedWeight = reportTypeSelfReportedWeight
        exposureConfiguration.reportTypeRecursiveWeight = reportTypeRecursiveWeight
        if let reportTypeNoneMap = ENDiagnosisReportType(rawValue: UInt32(reportTypeNoneMap)) {
            exposureConfiguration.reportTypeNoneMap = reportTypeNoneMap
        }
        
        exposureConfiguration.minimumRiskScore = minimumRiskScore
        exposureConfiguration.attenuationLevelValues = attenuationLevelValues as [NSNumber]
        exposureConfiguration.daysSinceLastExposureLevelValues = daysSinceLastExposureLevelValues as [NSNumber]
        exposureConfiguration.durationLevelValues = durationLevelValues as [NSNumber]
        exposureConfiguration.transmissionRiskLevelValues = transmissionRiskLevelValues as [NSNumber]
        exposureConfiguration.metadata = ["attenuationDurationThresholds": attenuationDurationThresholds]
        return exposureConfiguration
    }
}

extension ExposureConfiguration {
    static var mock: ExposureConfiguration {
        let str = """
        {
        "immediateDurationWeight":100,
        "nearDurationWeight":100,
        "mediumDurationWeight":100,
        "otherDurationWeight":100,
        "infectiousnessForDaysSinceOnsetOfSymptoms":{
            "unknown":1,
            "-14":1,
            "-13":1,
            "-12":1,
            "-11":1,
            "-10":1,
            "-9":1,
            "-8":1,
            "-7":1,
            "-6":1,
            "-5":1,
            "-4":1,
            "-3":1,
            "-2":1,
            "-1":1,
            "0":1,
            "1":1,
            "2":1,
            "3":1,
            "4":1,
            "5":1,
            "6":1,
            "7":1,
            "8":1,
            "9":1,
            "10":1,
            "11":1,
            "12":1,
            "13":1,
            "14":1
        },
        "infectiousnessStandardWeight":100,
        "infectiousnessHighWeight":100,
        "reportTypeConfirmedTestWeight":100,
        "reportTypeConfirmedClinicalDiagnosisWeight":100,
        "reportTypeSelfReportedWeight":100,
        "reportTypeRecursiveWeight":100,
        "reportTypeNoneMap":1,
        "minimumRiskScore":0,
        "attenuationDurationThresholds":[50, 70],
        "attenuationLevelValues":[1, 2, 3, 4, 5, 6, 7, 8],
        "daysSinceLastExposureLevelValues":[1, 2, 3, 4, 5, 6, 7, 8],
        "durationLevelValues":[1, 2, 3, 4, 5, 6, 7, 8],
        "transmissionRiskLevelValues":[1, 2, 3, 4, 5, 6, 7, 8]
        }
        """.data(using: .utf8)!
        
        return try JSONDecoder()
            .decode(ExposureConfiguration.self, from: str)
    }
}
