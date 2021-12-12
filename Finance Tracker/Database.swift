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


extension Transaction {
    init(row: Row) {
        do {
            try self.id = row.get(Expression<String>("id"))
            try self.amount = row.get(Expression<Double>("amount"))
            try self.name = row.get(Expression<String>("name"))
            try self.category = row.get(Expression<String>("category"))
            try self.dateandtime = row.get(Expression<Date>("dateandtime"))
            try self.repeattag = row.get(Expression<Int>("repeattag"))
            try self.endrepeat = row.get(Expression<Bool>("endrepeat"))
            try self.repeatenddate = row.get(Expression<Date>("repeatenddate"))
        } catch {
            self.id = ""
            self.amount = 1.0
            self.name = ""
            self.category = ""
            self.dateandtime = Date.now
            self.repeattag = 0
            self.endrepeat = false
            self.repeatenddate = Date.now
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
            try self.dateandtime = row.get(Expression<Date>("dateandtime"))
        } catch {
            self.id = ""
            self.amount = 1.0
            self.name = ""
            self.category = ""
            self.dateandtime = Date.now
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
            try self.category = row.get(Expression<String>("category"))
        } catch {
            self.category = ""
            print(error)
        }
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
    
    let nameTable = Table("names")
    
    let minusCategoryTable = Table("minusCategories")
    let minusCategory = Expression<String>("minusCategory")

    let plusCategoryTable = Table("plusCategories")
    let plusCategory = Expression<String>("plusCategory")
    
    func connectToDatabase() {
        do {
            debugPrint("sucess")
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            let db = try Connection(path.appendingPathComponent("database").appendingPathExtension("sqlite3").absoluteString)
            self.db = db
        } catch {
            print(error)
        }
    }
    
    func createTables() {
        let createTransactionTable = transactionTable.create(ifNotExists: true) { table in
            table.column(id)
            table.column(amount)
            table.column(name)
            table.column(category)
            table.column(dateandtime)
            table.column(repeattag)
            table.column(endrepeat)
            table.column(repeatenddate)
        }
            
        let createNameTable = nameTable.create(ifNotExists: true) { table in
            table.column(name)
        }
        
        let createMinusCategoryTable = minusCategoryTable.create(ifNotExists: true) { table in
            table.column(minusCategory, unique: true)
//            insertDefaultCategories
        }
        
        let createPlusCategoryTable = plusCategoryTable.create(ifNotExists: true) { table in
            table.column(plusCategory, unique: true)
//            insertDefaultCategories
        }
        
        do {
            try db.run(createTransactionTable)
            try db.run(createNameTable)
            try db.run(createMinusCategoryTable)
            try db.run(createPlusCategoryTable)
        } catch {
            print(error)
        }
    }
    
    func insertMinusCategory(category: String) {
        let insert = minusCategoryTable.insert(
            minusCategory <- category
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getMinusCategories() -> [Category] {
        var categories: [Category] = []
        do {
            let categoryRows = Array(try db.prepare(minusCategoryTable
                                                        .select(minusCategory)
                                                        .order(minusCategory.asc)
                                                   ))
            for categoryRow in categoryRows {
                let category = Category.init(row: categoryRow)
                categories.append(category)
            }
        } catch {
            print(error)
        }
        return categories
    }
    
    func insertPlusCategory(category: String) {
        let insert = plusCategoryTable.insert(
            plusCategory <-  category
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getPlusCategories() -> [Category] {
        var categories: [Category] = []
        do {
            let categoryRows = Array(try db.prepare(plusCategoryTable
                                                        .select(plusCategory)
                                                        .order(plusCategory.asc)
                                                   ))
            for categoryRow in categoryRows {
                let category = Category.init(row: categoryRow)
                categories.append(category)
            }
        } catch {
            print(error)
        }
        return categories
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
    
    func getAllTransactions() -> [Transaction] {
        var transactions: [Transaction] = []
        do {
            let transactionRows = Array(try db.prepare(transactionTable))
            for transactionRow in transactionRows {
                let transaction = Transaction.init(row: transactionRow)
                transactions.append(transaction)
            }
        } catch {
            print(error)
        }
        return transactions
    }
    
    func getTransactionsForHistory() -> [HistoryTransaction] {
        var transactions: [HistoryTransaction] = []
        do {
            let transactionRows = Array(try db.prepare(transactionTable
                                                        .select(id, amount, name, category, dateandtime)
                                                      ))
            for transactionRow in transactionRows {
                let transaction = HistoryTransaction.init(row: transactionRow)
                transactions.append(transaction)
            }
        } catch {
            print(error)
        }
        return transactions
    }
    
    func getMonthlyBalance() -> Double {
        var monthlyBalance: Double
        var amounts: [Amount] = []
        do {
            let amountRows = Array(try db.prepare(transactionTable
                                                            .select(amount)
                                                            .filter(Date().startOfMonth()...Date().endOfMonth() ~= dateandtime)
                                                         ))
            for amountRow in amountRows {
                let amount  = Amount.init(row: amountRow)
                amounts.append(amount)
            }
        } catch {
            print(error)
        }
        monthlyBalance = amounts.map({$0.amount}).reduce(0, +)
        return monthlyBalance
    }
}
