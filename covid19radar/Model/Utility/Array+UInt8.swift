//
//  UInt8+Random.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension Array where Element == UInt8 {
    static var padding: String {
        var size = Int.random(in: 1024..<2048)
        size = Int(Double(size) * 0.75)
        let bytes = [UInt8].secureRandomBytes(count: size) ?? []
        return Data(bytes).base64EncodedString()
    }
    
    static func secureRandomBytes(count: Int) -> [UInt8]? {
        var bytes = [UInt8](repeating: 0, count: count)

        // Fill bytes with secure random data
        let status = SecRandomCopyBytes(
            kSecRandomDefault,
            count,
            &bytes
        )

        if status == errSecSuccess {
            return bytes
        }
        else {
            return nil
        }
    }
}
