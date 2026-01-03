//
//  BundleExtension.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

import Foundation


extension Bundle {
    
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    }
}
