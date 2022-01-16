//
//  Config.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import Foundation

struct Configure: Codable {
    let apiKey: String
    let apiSecret: String
    let apiUrlBase: String
    let cdnUrlBase: String
}

extension Configure {
    static let plist: Configure = {
        let url = Bundle.main.url(forResource: "Environment", withExtension: "plist")!
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Configure.self, from: Data(contentsOf: url))
    }()
}
