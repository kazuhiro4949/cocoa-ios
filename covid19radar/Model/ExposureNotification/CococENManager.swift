//
//  CococENManager.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/01.
//

import Foundation
import ExposureNotification

class CocoaENManager {
    static let shared = CocoaENManager()
    
    let enManager = ENManager()
}
