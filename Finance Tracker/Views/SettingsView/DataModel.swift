//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation
import SQLite
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
    
    func createdatabase() {
        do {
            let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let db = try Connection(path.appendingPathComponent("database.db").absoluteString)
            
            let transactionTable = Table("transactions")
            
            let id = Expression<Int>("id")
            let amount = Expression<Double>("amount")
            let name = Expression<String>("name")
            let category = Expression<String>("category")
            let dateandtime = Expression<Date>("dateandtime")
            let repeattag = Expression<Int>("repeattag")
            let endrepeat = Expression<Bool>("endrepeat")
            let repeatenddate = Expression<Date>("repeatenddate")
            
            try db.run(transactionTable.create { t in
                t.column(id, primaryKey: true)
                t.column(amount)
                t.column(name)
                t.column(category)
                t.column(dateandtime)
                t.column(repeattag)
                t.column(endrepeat)
                t.column(repeatenddate)
            })
            
            transactions.forEach { transaction in
                let insert = transactionTable.insert(amount <- transaction.amount )
                do {
                    try db.run(insert)
                } catch {
                    print(error)
                }
            }
            
            
        } catch {
            print(error)
        }
    }
}
