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
    @AppStorage("firstUse") var firstUse = true
    
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
    
    var db: Connection!
    
    let transactionTable = Table("transactions")
    let repeatTransactionTable = Table("repeatTransactions")
    
    let id = Expression<String>("id")
    let amount = Expression<Double>("amount")
    let name = Expression<String>("name")
    let category = Expression<String>("category")
    let dateAndTime = Expression<Date>("dateAndTime")
    let repeatTag = Expression<Int>("repeatTag")
    let endRepeat = Expression<Bool>("endRepeat")
    let repeatEndDate = Expression<Date>("repeatEndDate")
    let repeatId = Expression<String>("repeatId")
    
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
            table.column(repeatId)
        }
        
        let createRepeatTransactionTable = repeatTransactionTable.create(ifNotExists: true) { table in
            table.column(id)
            table.column(amount)
            table.column(name)
            table.column(category)
            table.column(dateAndTime)
            table.column(repeatTag)
            table.column(endRepeat)
            table.column(repeatEndDate)
            table.column(repeatId)
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
            try db.run(createRepeatTransactionTable)
            try db.run(createNameTable)
            try db.run(createExpenseCategoryTable)
            try db.run(createIncomeCategoryTable)
        } catch {
            print(error)
        }
    }
    
    func insertDefaults() {
        if firstUse {
            categoriesExpense.forEach { category in
                insertCategory(type: false, newCategory: category)
            }
            categoriesIncome.forEach { category in
                insertCategory(type: true, newCategory: category)
            }
            firstUse = false
        }
    }
    
    func getCategoryTable(type: Bool) -> Table {
        var table = Table("")
        
        if type {
            table = incomeCategoryTable
        } else {
            table = expenseCategoryTable
        }
        
        return table
    }
    
    
    func insertCategory(type: Bool, newCategory: String) {
        let table = getCategoryTable(type: type)
        
        let insert = table.insert(
            category <- newCategory
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func getCategories(type: Bool) -> [Category] {
        let table = getCategoryTable(type: type)
        
        var categories: [Category] = []
        do {
            let categoryRows = Array(try db.prepare(table
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
    
    func deleteCategory(type: Bool, name: String) {
        let table = getCategoryTable(type: type)
        
        let category = table.filter(category == name)
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
            repeatEndDate <- transaction.repeatEndDate,
            repeatId <- transaction.repeatId
        )
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func insertNextRepeatingTransaction(transaction: Transaction) {
        let transactionDate = Data().getNextRepeatDate(transaction: transaction)
        
        let insert = repeatTransactionTable.insert(
            id <- transaction.id,
            amount <- transaction.amount,
            name <- transaction.name,
            category <- transaction.category,
            dateAndTime <- transactionDate,
            repeatTag <- transaction.repeatTag,
            endRepeat <- transaction.endRepeat,
            repeatEndDate <- transaction.repeatEndDate,
            repeatId <- transaction.repeatId
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
    
    func getTransactionsForHistory(endDate: Date) -> [HistoryTransaction] {
        var transactions: [HistoryTransaction] = []
        do {
            let transactionRows = Array(try db.prepare(transactionTable
                                                        .select(id, amount, name, category, dateAndTime, repeatId)
                                                        .filter(dateAndTime < endDate)
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
    
    func getRepeatingTransactions() -> [Transaction] {
        var transactions: [Transaction] = []
        do {
            let transactionRows = Array(try db.prepare(repeatTransactionTable))
            for transactionRow in transactionRows {
                let transaction = Transaction.init(row: transactionRow)
                transactions.append(transaction)
            }
        } catch {
            print(error)
        }
        return transactions
    }
    
    func getTransactionsFromRepeatId(repeatUuid: String) -> [Transaction] {
        var transactions: [Transaction] = []
        do {
            let transactionRows = Array(try db.prepare(transactionTable
                                                        .filter(repeatId == repeatUuid)
                                                      ))
            for transactionRow in transactionRows {
                let transaction = Transaction.init(row: transactionRow)
                transactions.append(transaction)
            }
        } catch {
            print(error)
        }
        return transactions
    }
    
    func updateTransaction(transaction: Transaction) {
        let updateTransaction = transactionTable.filter(id == transaction.id)
        do {
            try db.run(updateTransaction.update(
                id <- transaction.id,
                amount <- transaction.amount,
                name <- transaction.name,
                category <- transaction.category,
                dateAndTime <- transaction.dateAndTime,
                repeatTag <- transaction.repeatTag,
                endRepeat <- transaction.endRepeat,
                repeatEndDate <- transaction.repeatEndDate,
                repeatId <- transaction.repeatId
            ))
        } catch {
            print(error)
        }
    }
    
    func updateRepeatingTransaction(transaction: Transaction) {
        let updateTransaction = repeatTransactionTable.filter(id == transaction.id)
        do {
            try db.run(updateTransaction.update(
                id <- transaction.id,
                amount <- transaction.amount,
                name <- transaction.name,
                category <- transaction.category,
                dateAndTime <- transaction.dateAndTime,
                repeatTag <- transaction.repeatTag,
                endRepeat <- transaction.endRepeat,
                repeatEndDate <- transaction.repeatEndDate,
                repeatId <- transaction.repeatId
            ))
        } catch {
            print(error)
        }
    }
    
    func deleteTransaction(uuid: String) {
        let transaction = transactionTable.filter(id == uuid)
        do {
            try db.run(transaction.delete())
        } catch {
            print(error)
        }
    }
    
    func deleteFutureTransactions(uuid: String, date: Date) {
        let transactions = transactionTable.filter(repeatId == uuid && dateAndTime >= date)
        do {
            try db.run(transactions.delete())
        } catch {
            print(error)
        }
    }
    
    func deleteRepeatingTransaction(uuid: String) {
        let transaction = repeatTransactionTable.filter(repeatId == uuid)
        do {
            try db.run(transaction.delete())
        } catch {
            print(error)
        }
    }
    
    func getBalance(startDate: Date, endDate: Date) -> Double {
        var monthlyBalance: Double
        var amounts: [Amount] = []
        do {
            let amountRows = Array(try db.prepare(transactionTable
                                                    .select(amount)
                                                    .filter(startDate...endDate ~= dateAndTime)
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
