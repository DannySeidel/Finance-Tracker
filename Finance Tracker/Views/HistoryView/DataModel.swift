//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation

class Data: ObservableObject {
    @Published var amount: Double
    @Published var name: String
    @Published var category: String
    
    init(amount: Double, name: String, category: String) {
        self.amount = 9.11
        self.name = name
        self.category = category
    }
}
