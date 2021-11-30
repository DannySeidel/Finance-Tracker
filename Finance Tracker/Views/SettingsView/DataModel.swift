//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation
import SwiftUI

struct DataStructure: Hashable, Identifiable {
    var id = UUID().uuidString
    var amount: Double
    var name: String
    var category: String
    var dateandtime: Date
    var repeattag: Int
    var endrepeat: Bool
    var repeatenddate: Date
}

class Data: ObservableObject {
    @Published var transactions: [DataStructure] = []
    
    var db: Database = {
        debugPrint("data")
        var instance = Database()
        instance.connecttoDatabase()
        instance.createTable()
        instance.insertTransactionsintoDatabase(transaction: DataStructure(amount: 43, name: "fgds", category: "fsdbx", dateandtime: Date.now, repeattag: 0, endrepeat: true, repeatenddate: Date.distantFuture))
        return instance
    }()
    
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
