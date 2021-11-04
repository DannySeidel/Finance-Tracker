//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation
import SwiftUI

struct DataStructure: Hashable {
    var amount: Double
    var name: String
    var category: String
    var date: Date
    var repeatT: Int
//    var enddate: Date
//    var coordinates: Coordinates
    
    struct Coordinates: Hashable {
        var latitude: Double
        var longitude: Double
    }
}

class TransactionData: ObservableObject {
    @Published var transaction: [DataStructure] = []
    
    func addTransaction(transactionID: Int) {
        transaction[0] = DataStructure(amount: 34.1, name: "df", category: "food", date: Date.now, repeatT: 2)
    }
}
