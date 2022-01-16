//
//  URL+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension URL {
    static var termsWebPage = URL(string: .mhlwDomain + "/cocoa/kiyaku_japanese.html")!
    static var privacyPolicyWebPage = URL(string: .mhlwDomain + "/cocoa/privacypolicy_japanese.html")!
    
    static var userRegistration = URL(string: .apiDomain + "/api/register")!
    
    static var diagnosisSubmission = URL(string: .apiDomain + "/api/v3/diagnosis")!
    
    static var getConfiguration = URL(string: .githubIoDomain + "/cocoa/exposure_configuration/Cappuccino/test/configuration_slot1.json")!
    
    static var getDiagnosisKeyList = URL(string: .githubIoDomain + "/c19r/440/list.json")!
}

extension String {
    static let mhlwDomain = "https://www.mhlw.go.jp"
    
    static let apiDomain = Configure.plist.apiUrlBase
    
    static let cdnDomain = Configure.plist.cdnUrlBase
    
    static let githubIoDomain = "https://cocoa-mhlw.github.io/"
}
