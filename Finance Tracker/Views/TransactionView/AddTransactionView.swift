//
//  AddTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var showTransactionSheet: Bool
    
    @EnvironmentObject var data: Data
    @State private var transactionType = 0
    @State private var amounttemp: Double?
    @State private var nametemp: String?
    @State private var categorytemp: String?
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        AmountView(amounttemp: $amounttemp)
                        InfoView(nametemp: $nametemp, categroytemp: $categorytemp)
                        DateView()
                        MapView()
                    }
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                showTransactionSheet.toggle()
                            }
                            VStack {
                                Picker("", selection: $transactionType) {
                                    Image(systemName: "minus").tag(0)
                                    Image(systemName: "plus").tag(1)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                                
                            }
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Add") {
                            showTransactionSheet.toggle()
                            save()
                            debugPrint(data.transactions[0])
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
        }
        .preferredColorScheme(.dark)
    }
    func save() {
        if let amounttemp = amounttemp, let nametemp = nametemp, let categorytemp = categorytemp {
            data.transactions.append(DataStructure(amount: amounttemp, name: nametemp, category: categorytemp))
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
    }
}
