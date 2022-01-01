//
//  DateFormatter+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension DateFormatter {
    
    /// e.g. 2022-01-01T00:00:00.000+09:00
    static let timeStamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        return formatter
    }()
}


