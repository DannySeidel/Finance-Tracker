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
    var dateandtime: Date
    var repeattag: Int
    var endrepeat: Bool
    var repeatenddate: Date
}


struct HistoryTransaction: Hashable, Identifiable {
    var id: String
    var amount: Double
    var name: String
    var category: String
    var dateandtime: Date
}


struct Amount: Hashable {
    var amount: Double
}


struct Category: Hashable {
    var name: String
}


class Data: ObservableObject {
    
    var database: Database = {
        var instance = Database()
        instance.connectToDatabase()
        instance.createTables()
        return instance
    }()
    
    @Published var balance = 0.0
    
    @Published var transactionGroups: [[HistoryTransaction]] = [[]]

    init() {
        refreshBalance()
        refreshTransactionGroups()
    }
    
    func refreshBalance() {
        balance = database.getMonthlyBalance()
    }
    
    func refreshTransactionGroups() {
        var groups: [[HistoryTransaction]] = []
        for transaction in database.getTransactionsForHistory() {
            var groupexists = false
            for group in groups {
                if let firstGroup = group.first, Calendar.current.isDate(
                    firstGroup.dateandtime, inSameDayAs: transaction.dateandtime
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
    
    @Published var categoriesminus = [
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
    
    @Published var categoriesplus = [
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
