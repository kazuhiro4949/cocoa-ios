//
//  DateFormatter+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation

extension DateFormatter {
    
    /// ISO8601 e.g. 2022-01-01T00:00:00.000+09:00
    static let timeStamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        return formatter
    }()
    
    /// e.g. 2022-01-01 00:00
    static let helthcheckLabel: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle =  .short
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// e.g. 2022-01-01
    static let dateLabel: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle =  .none
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}


