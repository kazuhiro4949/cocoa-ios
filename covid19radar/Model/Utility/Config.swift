//
//  Config.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import Foundation

struct Environment: Codable {
    let apiKey: String
    let apiSecret: String
    let apiUrlBase: String
    let cdnUrlBase: String
}

extension Environment {
    static let plist: Environment = {
        let url = Bundle.main.url(forResource: "Environment", withExtension: "plist")!
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Config.self, from: Data(contentsOf: url))
    }()
}
