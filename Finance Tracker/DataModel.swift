//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation
import SwiftUI
import SQLite


struct Transaction: Hashable, Identifiable {
    var id = UUID().uuidString
    var amount: Double
    var name: String
    var category: String
    var dateAndTime: Date
    var repeatTag: Int
    var endRepeat: Bool
    var repeatEndDate: Date
    var repeatId = UUID().uuidString
}


struct HistoryTransaction: Hashable, Identifiable {
    var id: String
    var amount: Double
    var name: String
    var category: String
    var dateAndTime: Date
    var repeatId: String
}


struct Amount: Hashable {
    var amount: Double
}


struct Category: Hashable {
    var name: String
}


class Data: ObservableObject {
    @AppStorage("defaultTimespan") var defaultTimespan: Int = 0
    @AppStorage("currentMonth") var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    var database: Database = {
        var instance = Database()
        instance.connectToDatabase()
        instance.createTables()
        instance.insertDefaults()
        return instance
    }()
    
    @Published var balance = 0.0
    
    @Published var transactionGroups: [[HistoryTransaction]] = [[]]
    
    init() {
        addRepeatingTransactions()
        refreshBalance()
        refreshTransactionGroups()
    }
    
    func refreshBalance() {
        switch defaultTimespan {
        case 1:
            balance = database.getBalance(startDate: Date().todayOneMonthAgo(), endDate: Date())
        case 2:
            balance = database.getBalance(startDate: Date().startOfLastMonth(), endDate: Date().startOfCurrentMonth())
        case 3:
            balance = database.getBalance(startDate: Date().startOfMonthThreeMonthsAgo(), endDate: Date().startOfCurrentMonth())
        case 4:
            balance = database.getBalance(startDate: Date().startOfMonthSixMonthsAgo(), endDate: Date().startOfCurrentMonth())
        case 5:
            balance = database.getBalance(startDate: Date().startOfCurrentYear(), endDate: Date())
        case 6:
            balance = database.getBalance(startDate: Date().startOfLastYear(), endDate: Date().startOfCurrentYear())
        case 7:
            balance = database.getBalance(startDate: Date().todayOneYearAgo(), endDate: Date())
        case 8:
            balance = database.getBalance(startDate: Date.distantPast, endDate: Date.distantFuture)
        default:
            balance = database.getBalance(startDate: Date().startOfCurrentMonth(), endDate: Date())
        }
    }
    
    func refreshTransactionGroups() {
        var date = Date()
        if defaultTimespan == 8 {
            date = Date.distantFuture
        }
        var groups: [[HistoryTransaction]] = []
        for transaction in database.getTransactionsForHistory(endDate: date) {
            var groupexists = false
            for group in groups {
                if let firstGroup = group.first, Calendar.current.isDate(
                    firstGroup.dateAndTime, inSameDayAs: transaction.dateAndTime
                ) {
                    let groupIndex = groups.firstIndex(of: group)!
                    var newGroup = groups[groupIndex]
                    newGroup.append(transaction)
                    groups[groupIndex] = newGroup
                    groupexists = true
                }
            }
            if !groupexists {
                groups.append([transaction])
            }
        }
        transactionGroups = groups
    }
    
    func getRepeatDates(dateAndTime: Date, repeatEndDate: Date, repeatTag: Int) -> [Date] {
        var transactionDate = dateAndTime
        var repeatDates: [Date] = []
        while transactionDate <= repeatEndDate {
            repeatDates.append(transactionDate)
            switch repeatTag {
            case 1:
                transactionDate = Calendar.current.date(byAdding: .day, value: 1, to: transactionDate)!
            case 2:
                transactionDate = Calendar.current.date(byAdding: .day, value: 7, to: transactionDate)!
            case 3:
                transactionDate = Calendar.current.date(byAdding: .month, value: 1, to: transactionDate)!
            default:
                transactionDate = Calendar.current.date(byAdding: .year, value: 1, to: transactionDate)!
            }
        }
        return repeatDates
    }
    
    func getNextRepeatDate(transaction: Transaction) -> Date {
        var transactionDate = transaction.dateAndTime
        while transactionDate <= Date().StartOfNextMonth() {
            switch transaction.repeatTag {
            case 1:
                transactionDate = Calendar.current.date(byAdding: .day, value: 1, to: transactionDate)!
            case 2:
                transactionDate = Calendar.current.date(byAdding: .day, value: 7, to: transactionDate)!
            case 3:
                transactionDate = Calendar.current.date(byAdding: .month, value: 1, to: transactionDate)!
            default:
                transactionDate = Calendar.current.date(byAdding: .year, value: 1, to: transactionDate)!
            }
        }
        return transactionDate
    }
    
    func addRepeatingTransactions() {
        if currentMonth != Calendar.current.component(.month, from: Date()) {
            let transactions = database.getRepeatingTransactions()
            for transaction in transactions {
                let repeatUuid = UUID().uuidString
                let dates = getRepeatDates(dateAndTime: transaction.dateAndTime, repeatEndDate: Date().StartOfNextMonth(), repeatTag: transaction.repeatTag)
                
                for date in dates {
                    database.insertTransaction(
                        transaction: Transaction(
                            amount: transaction.amount,
                            name: transaction.name,
                            category: transaction.category,
                            dateAndTime: date,
                            repeatTag: transaction.repeatTag,
                            endRepeat: transaction.endRepeat,
                            repeatEndDate: transaction.repeatEndDate,
                            repeatId: repeatUuid
                        )
                    )
                }
                
                let repeatDate = getNextRepeatDate(transaction: transaction)
                
                database.deleteRepeatingTransaction(uuid: transaction.repeatId)
                
                database.insertNextRepeatingTransaction(
                    transaction: Transaction(
                        amount: transaction.amount,
                        name: transaction.name,
                        category: transaction.category,
                        dateAndTime: repeatDate,
                        repeatTag: transaction.repeatTag,
                        endRepeat: transaction.endRepeat,
                        repeatEndDate: transaction.repeatEndDate,
                        repeatId: repeatUuid
                    )
                )
            }
            currentMonth = Calendar.current.component(.month, from: Date())
        }
    }
    
    @Published var categoriesExpense = [
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
    
    @Published var categoriesIncome = [
        "Business Income",
        "Salary",
        "Stock Market",
        "Tax Refunds"
    ]
    
    @Published var names = [
        "Breakfest",
        "Lunch",
        "Coffee",
        "Dinner",
        "Theather",
        "Amusement Park",
        "Aldi",
        "Edeka",
        "Lidl",
        "tegut",
        "Netto",
        "Norma",
        "Penny",
        "Car",
        "Bike",
        "E-Scooter",
        "Public Transport",
        "Taxi",
        "Train",
        "Airplane",
    ]
}
