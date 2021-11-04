//
//  DataModel.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import Foundation

class Data: ObservableObject {
//    @Published var transaction:
    @Published var amount: [Double] = []
    @Published var name: [String] = []
    @Published var category: [String] = []    
}
