//
//  ManageCategoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 11.11.21.
//

import SwiftUI

struct ManageCategoryView: View {
    @State private var categorytype = false
    
    var body: some View {
        VStack {
            Picker("", selection: $categorytype) {
                Label("Expense", systemImage: "minus")
                    .tag(false)
                Label("Income", systemImage: "plus")
                    .tag(true)
            }
            .pickerStyle(.segmented)
            .padding()
            .navigationTitle("Edit Categories")
            
            Spacer()
        }
    }
}

struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ManageCategoryView()
            .preferredColorScheme(.dark)
    }
}
