//
//  ReportType.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

public enum ReportType: Int, Codable
{
    case unknown
    case confirmedTest
    case confirmedClinicalDiagnosis
    case selfReport
    case recursive
    case revoked
}
