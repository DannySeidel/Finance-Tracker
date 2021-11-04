//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation

struct DataStructure: Hashable {
    var amount: Double
    var name: String
    var category: String
}

class Data: ObservableObject {
    @Published var transactions: [DataStructure] = []
}
