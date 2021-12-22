//
//  Extensions.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 22.12.21.
//

import Foundation
import SQLite


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month],from: Calendar.current.startOfDay(for: self)
            )
        )!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(
            byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()
        )!
    }
}


extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}


extension Transaction {
    init(row: Row) {
        do {
            try self.id = row.get(Expression<String>("id"))
            try self.amount = row.get(Expression<Double>("amount"))
            try self.name = row.get(Expression<String>("name"))
            try self.category = row.get(Expression<String>("category"))
            try self.dateAndTime = row.get(Expression<Date>("dateAndTime"))
            try self.repeatTag = row.get(Expression<Int>("repeatTag"))
            try self.endRepeat = row.get(Expression<Bool>("endRepeat"))
            try self.repeatEndDate = row.get(Expression<Date>("repeatEndDate"))
        } catch {
            self.id = ""
            self.amount = 1.0
            self.name = ""
            self.category = ""
            self.dateAndTime = Date.now
            self.repeatTag = 0
            self.endRepeat = false
            self.repeatEndDate = Date.now
            print(error)
        }
    }
}


extension HistoryTransaction {
    init(row: Row) {
        do {
            try self.id = row.get(Expression<String>("id"))
            try self.amount = row.get(Expression<Double>("amount"))
            try self.name = row.get(Expression<String>("name"))
            try self.category = row.get(Expression<String>("category"))
            try self.dateAndTime = row.get(Expression<Date>("dateAndTime"))
        } catch {
            self.id = ""
            self.amount = 1.0
            self.name = ""
            self.category = ""
            self.dateAndTime = Date.now
            print(error)
        }
    }
}


extension Amount {
    init(row: Row) {
        do {
            try self.amount = row.get(Expression<Double>("amount"))
        } catch {
            self.amount = 1.0
            print(error)
        }
    }
}


extension Category {
    init(row: Row) {
        do {
            try self.name = row.get(Expression<String>("category"))
        } catch {
            self.name = "fail"
            print(error)
        }
    }
}
