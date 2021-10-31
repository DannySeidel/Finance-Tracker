//
//  AddTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AddTransactionView: View {
    @State private var showTransactionSheet = true
    @State private var transactionType = 0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        TransactionContentView()
                    }
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                showTransactionSheet.toggle()
                            }
                            .foregroundColor(Color(.white))
                            Picker("", selection: $transactionType) {
                                Image(systemName: "minus").tag(0)
                                Image(systemName: "plus").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 150)
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Add") {
                            
                        }
                        .foregroundColor(Color(.white))
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
