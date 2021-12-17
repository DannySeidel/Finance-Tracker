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
    @State private var amount: Double?
    @State private var name: String?
    @State private var category: String?
    @State private var dateAndTime = Date()
    @State private var repeatTag = 0
    @State private var endRepeat = false
    @State private var repeatEndDate = Date()
    
    @State private var transactionType = false
    @State private var showingAlert = false
    
    @AppStorage("storeNewCategoriesByDefault") var storeNewCategoriesByDefault = true
    
    var factor: Double {
        transactionType ? 1 : -1
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        AmountView(amountTemp: $amount)
                        InfoView(nameTemp: $name, categroyTemp: $category, transactionTypeTemp: $transactionType)
                        DateView(dateAndTime: $dateAndTime, repeatTag: $repeatTag, endRepeat: $endRepeat, repeatEndDate: $repeatEndDate)
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
                                    Image(systemName: "minus").tag(false)
                                    Image(systemName: "plus").tag(true)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                                
                            }
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Add") {
                            if (amount != nil) {
                                if name == nil {
                                    name = "unnamed Transaction"
                                }
                                if category == nil {
                                    category = "no Category"
                                }
                                data.database.insertTransaction(
                                    transaction: Transaction(
                                        amount: amount! * factor,
                                        name: name!,
                                        category: category!,
                                        dateAndTime: dateAndTime,
                                        repeatTag: repeatTag,
                                        endRepeat: endRepeat,
                                        repeatEndDate: repeatEndDate
                                    )
                                )
                                if storeNewCategoriesByDefault {
                                    transactionType ? data.database.insertIncomeCategory(newCategory: category!) : data.database.insertExpenseCategory(newCategory: category!)
                                }
                            } else {
                                showingAlert.toggle()
                            }
                            data.refreshBalance()
                            data.refreshTransactionGroups()
                            showTransactionSheet.toggle()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Missing an amount"))
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
