//
//  DiagnosisSubmission.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

struct DiagnosisSubmission: Codable {
    struct Key: Codable {
        let keyData: String
        let rollingStartNumber: UInt
        let rollingPeriod: UInt
        let reportType: UInt
    }
    
    let symptomOnsetDate: String
    let keys: [Key]
    let regions: [String]
    let platform: String
    let deviceVerificationPayload: String
    let appPackageName: String
    let verificationPayload: String
    let idempotency_key: String // TODO: - change after
    let padding: String
}
