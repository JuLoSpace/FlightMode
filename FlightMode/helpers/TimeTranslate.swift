//
//  TimeTranslate.swift
//  FlightMode
//
//  Created by Ярослав Соловьев on 09.01.2026.
//


class TimeTranslate {
    
    static func secToString(_ seconds: Double) -> String {
        let secs: Int = Int(seconds)
        let m: Int = secs / 60
        let h: Int = m / 60
        let minutes = m % 60
        var out: String = ""
        if (h > 0) {
            out += "\(h) H"
        }
        out += "\(minutes) MIN"
        return out
    }
}
