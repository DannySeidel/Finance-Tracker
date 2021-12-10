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

struct Amount: Hashable {
    var amount: Double
}


class Data: ObservableObject {
    
    var database: Database = {
        var instance = Database()
        instance.connectToDatabase()
        instance.createTables()
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
