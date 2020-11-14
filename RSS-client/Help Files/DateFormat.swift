//
//  DateFormat.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import Foundation


class DateFormatManager {
    
    private let totalDateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    private let startDateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return dt
    }()
    
    func convertDate(from startFormat: String) -> String {
        if let date = self.startDateFormatter.date(from: startFormat) {
            let interval = Date().timeIntervalSince(date)
            if interval < 60*60 {
                let x = Int(interval/60)
                if x%100 == 11 || x%100 == 12, x%100 == 13, x%100 == 14 {
                    return "\(x) минут назад"
                }
                if x%10 == 1 {
                    return "\(x) минуту назад"
                }
                if x%10 == 2 || x%10 == 3 || x%10 == 4 {
                    return "\(x) минуты назад"
                }
                return "\(x) минут назад"
            } else {
                return self.totalDateFormatter.string(from: date)
            }
        }
        return "error"
    }
}
