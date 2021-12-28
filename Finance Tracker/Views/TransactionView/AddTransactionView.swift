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
                            addTransaction()
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color.init(UIColor(named: "AppText")!))
                .background(Color.init(UIColor(named: "AppSheetBackground")!))
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Missing an amount"))
            }
        }
    }
    
    private func addTransaction() {
        if (amount != nil) {
            let repeatUuid = UUID().uuidString
            let dates = data.getRepeatDates(dateAndTime: dateAndTime, repeatEndDate: endRepeat ? repeatEndDate : Date().StartOfNextMonth(), repeatTag: repeatTag)
            
            for date in dates {
                data.database.insertTransaction(
                    transaction: Transaction(
                        amount: amount! * factor,
                        name: name ?? "unnamed Transaction",
                        category: category ?? "no Category",
                        dateAndTime: date,
                        repeatTag: repeatTag,
                        endRepeat: endRepeat,
                        repeatEndDate: repeatEndDate,
                        repeatId: repeatUuid
                    )
                )
            }
            
            if !endRepeat {
                data.database.insertNextRepeatingTransaction(
                    transaction: Transaction(
                        amount: amount! * factor,
                        name: name ?? "unnamed Transaction",
                        category: category ?? "no Category",
                        dateAndTime: dateAndTime,
                        repeatTag: repeatTag,
                        endRepeat: endRepeat,
                        repeatEndDate: repeatEndDate,
                        repeatId: repeatUuid
                    )
                )
            }
            
            if storeNewCategoriesByDefault && category != nil {
                transactionType ? data.database.insertIncomeCategory(newCategory: category!) : data.database.insertExpenseCategory(newCategory: category!)
            }
            
            data.refreshBalance()
            data.refreshTransactionGroups()
            showTransactionSheet.toggle()
        } else {
            showingAlert.toggle()
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
