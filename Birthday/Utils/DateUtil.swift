//
//  Util.swift
//  Birthday
//
//  Created by admin on 12/08/2017.
//  Copyright © 2017 theteam247.com. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    
    static private let birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    static private let alertTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    static private let nextTriggerTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mm a"
        return formatter
    }()

    static func birthdayTimeString(from date: Date?) -> String {
        guard let d = date else { return "" }
        return birthdayFormatter.string(from: d)
    }
    static func alertTimeString(from date: Date?) -> String {
        guard let d = date else { return "" }
        return alertTimeFormatter.string(from: d)
    }
    static func nextTriggerTimeString(from date: Date?) -> String {
        guard let d = date else { return "" }
        return nextTriggerTimeFormatter.string(from: d)
    }
    
    static func getBirthdayAlertTime(from birthday: Date, alertTime: Date) -> Date? {
        let birthdayCom = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let alertTimeCom = Calendar.current.dateComponents([.hour, .minute], from: alertTime)
        var dateComs = DateComponents()
        dateComs.year = birthdayCom.year
        dateComs.month = birthdayCom.month
        dateComs.day = birthdayCom.day
        dateComs.hour = alertTimeCom.hour
        dateComs.minute = alertTimeCom.minute
        return Calendar.current.date(from: dateComs)
    }
    
    static func getNextBirthdayTriggerTime(from birthday: Date, alertTime: Date) -> Date? {
        let birthdayCom = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let alertTimeCom = Calendar.current.dateComponents([.hour, .minute], from: alertTime)
        let today = Date()
        let todayCom = Calendar.current.dateComponents([.year], from: today)
        
        var dateComs = DateComponents()
        dateComs.year = todayCom.year
        dateComs.month = birthdayCom.month
        dateComs.day = birthdayCom.day
        dateComs.hour = alertTimeCom.hour
        dateComs.minute = alertTimeCom.minute
        
        if let thisYearBirthday = Calendar.current.date(from: dateComs) {
            if thisYearBirthday.compare(today) == .orderedAscending {
                dateComs.year = todayCom.year! + 1
                return Calendar.current.date(from: dateComs)
            }else {
                return thisYearBirthday
            }
        }
        return nil
    }
}
