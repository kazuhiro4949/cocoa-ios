//
//  Config.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import Foundation

struct Config: Codable {
    let apiKey: String
    let apiSecret: String
    let apiUrlBase: String
    let cdnUrlBase: String
}

extension Config {
    static let plist: Config = {
        let url = Bundle.main.url(forResource: "Environment", withExtension: "plist")!
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Config.self, from: Data(contentsOf: url))
    }()
}
