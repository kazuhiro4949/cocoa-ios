//
//  URLRequest+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension URLRequest {
    static func makeDiagnosisSubmission(_ diagnosisSubmission: DiagnosisSubmission) throws -> URLRequest {
        var request = URLRequest(url: .diagnosisSubmission)
        let encoder = JSONEncoder()
        let jsonBody = try encoder.encode(diagnosisSubmission)
        request.httpMethod = "PUT"
        request.httpBody = jsonBody
        return request
    }
}
