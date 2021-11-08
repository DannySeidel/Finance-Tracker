//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation

struct DataStructure: Hashable, Identifiable {
    var id: Int
    var transactiontype: Bool
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
}

//let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
//let db = try Connection(path.appendingPathComponent("database.db").absoluteString)

