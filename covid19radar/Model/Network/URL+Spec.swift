//
//  URL+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension URL {
    static var diagnosisSubmission = URL(string: .apiDomain + "/api/v3/diagnosis")!
    
    static var getConfiguration = URL(string: .githubIoDomain + "/cocoa/exposure_configuration/Cappuccino/test/configuration_slot1.json")!
    
    static var getDiagnosisKeyList = URL(string: .githubIoDomain + "/c19r/440/list.json")!
}

extension String {
    static var apiDomain = "" //TODO: -
    
    static var cdnDomain = "" //TODO: -
    
    static var githubIoDomain = "https://cocoa-mhlw.github.io/"
}
