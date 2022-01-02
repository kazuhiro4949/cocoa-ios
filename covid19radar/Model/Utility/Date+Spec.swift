//
//  Date+Spec.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/02.
//

import Foundation

extension Date {
    /// https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ExposureNotification-CryptographySpecificationv1.2.pdf
    var enInterval: Int {
        let timeIntervalSince1970 = Int(timeIntervalSince1970)
        return timeIntervalSince1970 / (60 * 10)
    }
}
