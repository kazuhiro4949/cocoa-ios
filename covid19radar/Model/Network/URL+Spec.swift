//
//  URL+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension URL {
    static var diagnosisSubmission = URL(string: .apiEndpoint + "/api/v3/diagnosis")!
}

extension String {
    static var apiEndpoint = "" //TODO: -
}
