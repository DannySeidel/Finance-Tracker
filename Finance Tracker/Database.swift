//
//  Database.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 29.11.21.
//

import Foundation
import SwiftUI
import SQLite

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}


class Database {
    @EnvironmentObject var data: Data
    
    var db: Connection!
    
    let transactionTable = Table("transactions")
    
    let id = Expression<String>("id")
    let amount = Expression<Double>("amount")
    let name = Expression<String>("name")
    let category = Expression<String>("category")
    let dateandtime = Expression<Date>("dateandtime")
    let repeattag = Expression<Int>("repeattag")
    let endrepeat = Expression<Bool>("endrepeat")
    let repeatenddate = Expression<Date>("repeatenddate")
    
    func connecttoDatabase() {
        do {
            debugPrint("sucess")
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let db = try Connection(path.appendingPathComponent("database").appendingPathExtension("sqlite3").absoluteString)
            self.db = db
        } catch {
            print(error)
        }
    }
    
    func createTable() {
        let createTable = transactionTable.create(ifNotExists: true) { table in
            table.column(id)
            table.column(amount)
            table.column(name)
            table.column(category)
            table.column(dateandtime)
            table.column(repeattag)
            table.column(endrepeat)
            table.column(repeatenddate)
        }
        
        do {
            try db.run(createTable)
        } catch {
            print(error)
        }
    }
    
    func insertTransaction(transaction: Transaction) {
        let insert = transactionTable.insert(
            id <- transaction.id,
            amount <- transaction.amount,
            name <- transaction.name,
            category <- transaction.category,
            dateandtime <- transaction.dateandtime,
            repeattag <- transaction.repeattag,
            endrepeat <- transaction.endrepeat,
            repeatenddate <- transaction.repeatenddate
        )
        
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func loadallTransactions() -> [Transaction] {
        do {
            let transactions = Array(try db.prepare(transactionTable))
            return transactions
        } catch {
            print(error)
        }
    }
    
//    func loadAmountsforCurrentMonth() -> [Transaction] {
//        do {
//            let transactionAmounts = Array(try db.prepare(transactionTable
//                                                            .select(amount)
//                                                            .filter(Date().startOfMonth()...Date().endOfMonth() ~= dateandtime)
//                                                         ))
//            return transactionAmounts
//        } catch {
//            print(error)
//        }
//    }
}
