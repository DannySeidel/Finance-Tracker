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


class Database {
    var categoriesExpense = [
        "Car",
        "Clothes",
        "Computers",
        "Entertainment",
        "Freetime",
        "Food & Drinks",
        "Gifts",
        "Groceries",
        "Health",
        "Household",
        "Rent",
        "Restaurants & Cafes",
        "Transport"
    ]
    
    var categoriesIncome = [
        "Business Income",
        "Salary",
        "Stock Market",
        "Tax Refunds"
    ]
    
    @EnvironmentObject var data: Data
    
    var db: Connection!
    
    let transactionTable = Table("transactions")
    
    let id = Expression<String>("id")
    let amount = Expression<Double>("amount")
    let name = Expression<String>("name")
    let category = Expression<String>("category")
    let dateAndTime = Expression<Date>("dateAndTime")
    let repeatTag = Expression<Int>("repeatTag")
    let endRepeat = Expression<Bool>("endRepeat")
    let repeatEndDate = Expression<Date>("repeatEndDate")
    
    let nameTable = Table("names")
    
    let expenseCategoryTable = Table("expenseCategories")

    let incomeCategoryTable = Table("incomeCategories")
    
    func connectToDatabase() {
        do {
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
            table.column(dateAndTime)
            table.column(repeatTag)
            table.column(endRepeat)
            table.column(repeatEndDate)
        }
            
        let createNameTable = nameTable.create(ifNotExists: true) { table in
            table.column(name, unique: true)
        }
        
        let createExpenseCategoryTable = expenseCategoryTable.create(ifNotExists: true) { table in
            table.column(category, unique: true)
        }
        
        let createIncomeCategoryTable = incomeCategoryTable.create(ifNotExists: true) { table in
            table.column(category, unique: true)
        }
        
        do {
            try db.run(createTransactionTable)
            try db.run(createNameTable)
            try db.run(createExpenseCategoryTable)
            try db.run(createIncomeCategoryTable)
        } catch {
            print(error)
        }
    }
    
    func insertDefaults() {
        categoriesExpense.forEach { category in
            insertExpenseCategory(newCategory: category)
        }
        categoriesIncome.forEach { category in
            insertIncomeCategory(newCategory: category)
        }
    }
    
    func insertExpenseCategory(newCategory: String) {
        let insert = expenseCategoryTable.insert(
            category <- newCategory
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getExpenseCategories() -> [Category] {
        var categories: [Category] = []
        do {
            let categoryRows = Array(try db.prepare(expenseCategoryTable
                                                        .order(category.asc)
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
    
    func deleteExpenseCategory(name: String) {
        let category = expenseCategoryTable.filter(category == name)
        do {
            try db.run(category.delete())
        } catch {
            print(error)
        }
    }
    
    func insertIncomeCategory(newCategory: String) {
        let insert = incomeCategoryTable.insert(
            category <-  newCategory
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getIncomeCategories() -> [Category] {
        var categories: [Category] = []
        do {
            let categoryRows = Array(try db.prepare(incomeCategoryTable
                                                        .order(category.asc)
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
    
    func deleteIncomeCategory(name: String) {
        let category = incomeCategoryTable.filter(category == name)
        do {
            try db.run(category.delete())
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
            dateAndTime <- transaction.dateAndTime,
            repeatTag <- transaction.repeatTag,
            endRepeat <- transaction.endRepeat,
            repeatEndDate <- transaction.repeatEndDate
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getTransactionFromId(uuid: String) -> Transaction {
        var transaction: Transaction = Transaction(amount: 1.0, name: "", category: "", dateAndTime: Date(), repeatTag: 0, endRepeat: true, repeatEndDate: Date())
        do {
            let transactionRows = Array(try db.prepare(transactionTable
                                                        .filter(uuid == id)
                                                      ))
            for transactionRow in transactionRows {
                transaction = Transaction.init(row: transactionRow)
            }
        } catch {
            print(error)
        }
        return transaction
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
                                                        .select(id, amount, name, category, dateAndTime)
                                                        .order(dateAndTime.desc)
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
    
    func deleteTransaction(uuid: String) {
        let transaction = transactionTable.filter(id == uuid)
        do {
            try db.run(transaction.delete())
        } catch {
            print(error)
        }
    }
    
    func getMonthlyBalance() -> Double {
        var monthlyBalance: Double
        var amounts: [Amount] = []
        do {
            let amountRows = Array(try db.prepare(transactionTable
                                                            .select(amount)
                                                            .filter(Date().startOfMonth()...Date().endOfMonth() ~= dateAndTime)
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
