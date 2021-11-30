//
//  Database.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 29.11.21.
//

import Foundation
import SwiftUI
import SQLite


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
            //            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
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
    
    func insertTransactionsintoDatabase(transaction: DataStructure) {
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
            debugPrint(transaction)
        } catch {
            print(error)
        }
    }
    
    //    func loadTransactionsfromDatabase() -> [DataStructure] {
    //        do {
    //            try db.run(transactionTable.create(ifNotExists: true) { t in
    //                t.column(id)
    //                t.column(amount)
    //                t.column(name)
    //                t.column(category)
    //                t.column(dateandtime)
    //                t.column(repeattag)
    //                t.column(endrepeat)
    //                t.column(repeatenddate)
    //            })
    //
    //        } catch {
    //            print(error)
    //        }
    //    }
    
}
