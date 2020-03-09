//
//  UserData.swift
//  FoodPointCalculator
//
//  Created by David Coffman on 10/10/19.
//  Copyright © 2019 David Coffman. All rights reserved.
//

import Foundation

var globalUserData = UserData.retrieveActive()

struct UserData: Codable {
    var startDate: Date
    var endDate: Date
    
    var swipeBalance: Int
    var pointBalance: Double
    
    var ignoreFallBreak: Bool
    private var fallBreakDates: [Date]
    
    var ignoreThanksgivingBreak: Bool
    private var thanksgivingBreakDates: [Date]
    
    var ignoreSpringBreak: Bool
    private var springBreakDates: [Date]
    
    var lastDisplayedAnnouncement: Date
    
    static func retrieveActive() -> UserData {
        if let userData = try? JSONDecoder().decode(UserData.self, from: Data(contentsOf: FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("data").appendingPathExtension("json"))) {
            if Date() > userData.endDate {
                return initializeUserData()
            }
            return userData
        }
        else {
            return initializeUserData()
        }
    }
    
    static func initializeUserData() -> UserData {
        let today = Date()
        let calendarSessions = try! JSONDecoder().decode([CalendarSession].self, from: Data(contentsOf: Bundle.main.url(forResource: "calendar", withExtension: "json")!))
        var activeCalendarSession: CalendarSession? = nil
        calendarSessionIterator: for k in calendarSessions {
            if k.endDate > today {
                activeCalendarSession = k
                break calendarSessionIterator
            }
        }
        let userData = UserData(startDate: Date(), endDate: activeCalendarSession!.endDate, swipeBalance: 0, pointBalance: 0, ignoreFallBreak: true, fallBreakDates: activeCalendarSession!.fallBreakDates, ignoreThanksgivingBreak: true, thanksgivingBreakDates: activeCalendarSession!.thanksgivingBreakDates, ignoreSpringBreak: true, springBreakDates: activeCalendarSession!.springBreakDates, lastDisplayedAnnouncement: Date())
        userData.save()
        return userData
    }
    
    func save() {
        let data = try! JSONEncoder().encode(self)
        try! data.write(to: FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("data").appendingPathExtension("json"))
    }
    
    func calcDaysRemaining(start: Date) -> Int {
        var daysRemaining = endDate.timeIntervalSince(start)/86400
        let startDate = start
        fallBreakHandler: if(ignoreFallBreak) {
            for k in fallBreakDates {
                if startDate <= k && endDate > k {
                    daysRemaining -= 1
                }
            }
        }
        
        thanksgivingBreakHandler: if(ignoreThanksgivingBreak) {
            for k in thanksgivingBreakDates {
                if startDate <= k && endDate > k {
                    daysRemaining -= 1
                }
            }
        }
        
        springBreakHandler: if(ignoreSpringBreak) {
            for k in springBreakDates {
                if startDate <= k && endDate > k {
                    daysRemaining -= 1
                }
            }
        }
        
        return Int(daysRemaining)+1
    }
    
    func calcPointsPerDay() -> Double {
        return pointBalance/Double(calcDaysRemaining(start: startDate))
    }

    func calcSwipesPerWeek() -> Double {
        if(calcDaysRemaining(start: startDate) <= 7) {
            return Double(swipeBalance)
        }
        return Double(swipeBalance)/Double(calcDaysRemaining(start:startDate))*7.0
    }
    
    func calcEODBalance() -> Double {
        return calcPointsPerDay()*Double(calcDaysRemaining(start: Date()))
    }
}

struct CalendarSession: Codable {
    var endDate: Date
    var fallBreakDates:[Date]
    var thanksgivingBreakDates: [Date]
    var springBreakDates: [Date]
}

struct Announcement: Codable {
    let isText: Bool
    let title: String?
    let bodyText: String?
    let imageURL: URL?
    let date: Date
}
