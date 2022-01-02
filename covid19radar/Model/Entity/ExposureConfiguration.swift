//
//  ExposureConfiguration.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/02.
//

import Foundation
import ExposureNotification

struct ExposureConfig: Codable, Equatable {
    let appleExposureConfigV1: ExposureConfigV1
    let appleExposureConfigV2: ExposureConfigV2
    
    func convertENConfig() async throws -> ENExposureConfiguration {
        let exposureConfiguration = ENExposureConfiguration()
        exposureConfiguration.immediateDurationWeight = appleExposureConfigV2.immediateDurationWeight
        exposureConfiguration.nearDurationWeight = appleExposureConfigV2.nearDurationWeight
        exposureConfiguration.mediumDurationWeight = appleExposureConfigV2.mediumDurationWeight
        exposureConfiguration.otherDurationWeight = appleExposureConfigV2.otherDurationWeight
        var infectiousnessForDaysSinceOnsetOfSymptoms = [Int: Int]()
        for (stringDay, infectiousness) in appleExposureConfigV2.infectiousnessForDaysSinceOnsetOfSymptoms {
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
        exposureConfiguration.infectiousnessStandardWeight = appleExposureConfigV2.infectiousnessStandardWeight
        exposureConfiguration.infectiousnessHighWeight = appleExposureConfigV2.infectiousnessHighWeight
        exposureConfiguration.reportTypeConfirmedTestWeight = appleExposureConfigV2.reportTypeConfirmedTestWeight
        exposureConfiguration.reportTypeConfirmedClinicalDiagnosisWeight = appleExposureConfigV2.reportTypeConfirmedClinicalDiagnosisWeight
        exposureConfiguration.reportTypeSelfReportedWeight = appleExposureConfigV2.reportTypeSelfReportedWeight
        exposureConfiguration.reportTypeRecursiveWeight = appleExposureConfigV2.reportTypeRecursiveWeight
        if let reportTypeNoneMap = ENDiagnosisReportType(rawValue: UInt32(appleExposureConfigV2.reportTypeNoneMap)) {
            exposureConfiguration.reportTypeNoneMap = reportTypeNoneMap
        }
        
        exposureConfiguration.minimumRiskScore = appleExposureConfigV2.minimumRiskScore // TODO: - v1 or v2 config?
        
        exposureConfiguration.attenuationLevelValues = appleExposureConfigV1.attenuationLevelValues as [NSNumber]
        exposureConfiguration.daysSinceLastExposureLevelValues = appleExposureConfigV1.daysSinceLastExposureLevelValues as [NSNumber]
        exposureConfiguration.durationLevelValues = appleExposureConfigV1.durationLevelValues as [NSNumber]
        exposureConfiguration.transmissionRiskLevelValues = appleExposureConfigV1.transmissionRiskLevelValues as [NSNumber]
//        exposureConfiguration.metadata = ["attenuationDurationThresholds": appleExposureConfigV1.attenuationDurationThresholds] // TODO: - needs this prop?
        return exposureConfiguration
    }
}

struct ExposureConfigV1: Codable, Equatable {
    let attenuationLevelValues: [ENRiskLevelValue]
    let daysSinceLastExposureLevelValues: [ENRiskLevelValue]
    let durationLevelValues: [ENRiskLevelValue]
    let transmissionRiskLevelValues: [ENRiskLevelValue]
    let minimumRiskScore: ENRiskScore
    let minimumRiskScoreFullRange: Double
}

struct ExposureConfigV2: Codable, Equatable {
    let infectiousnessWhenDaysSinceOnsetMissing: Int
    let Attenuation_duration_thresholds: [Int]
    let durationLevelValues: Double
    let transmissionRiskLevelValues: [Int]
    let minimumRiskScore: ENRiskScore
    let minimumRiskScoreFullRange: Double
    let immediateDurationWeight: Double
    let nearDurationWeight: Double
    let mediumDurationWeight: Double
    let otherDurationWeight: Double
    let DaysSinceLastExposureThreshold: Int // TODO: - wrong format
    let infectiousnessForDaysSinceOnsetOfSymptoms: [String: Int]
    let infectiousnessHighWeight: Double
    let infectiousnessStandardWeight: Double
    let reportTypeConfirmedClinicalDiagnosisWeight: Double
    let reportTypeConfirmedTestWeight: Double
    let reportTypeRecursiveWeight: Double
    let reportTypeSelfReportedWeight: Double
    let reportTypeNoneMap: Int
}


struct DiagnosisKeyEntry: Decodable {
    let region: Int
    
    @FailableDecodable
    var url: URL?
    
    let created: Int64
}

@propertyWrapper
struct FailableDecodable<Wrapped: Decodable>: Decodable {
    var wrappedValue: Wrapped?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try? container.decode(Wrapped.self)
    }
}
