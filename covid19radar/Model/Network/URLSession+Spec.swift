//
//  URLSession+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension URLSession {
    static var apiKeyBased: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "x-functions-key": "",
            "x-api-key": ""
        ]
        return URLSession(configuration: config)
    }()
    
    static var defaultApi: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "x-functions-key": "",
            "Accept": "*/*",
        ]
        return URLSession(configuration: config)
    }()

    static var download: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
}
