//
//  EditTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 15.12.21.
//

import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var data: Data
    
    @State private var amount: Double?
    @State private var name: String?
    @State private var category: String?
    @State private var dateAndTime = Date()
    @State private var repeatTag = 0
    @State private var endRepeat = false
    @State private var repeatEndDate = Date()
    
    @Binding var showingSheet: Bool
    @Binding var uuid: String
    @Binding var repeatUuid: String
    @Binding var transactionType: Bool
    
    @State private var showingAlert = false
    
    @AppStorage("storeNewCategoriesByDefault") var storeNewCategoriesByDefault = true
    
    var transaction: Transaction {
        data.database.getTransactionFromId(uuid: uuid)
    }
    
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
                    .background(Color.init(UIColor(named: "AppSheetBackground")!))
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                showingSheet.toggle()
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
                        Button("Save") {
                            updateTransaction()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Missing an amount"))
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color.init(UIColor(named: "AppText")!))
            }
            .onAppear(perform: initializeTransactionVariables)
        }
    }
    
    private func initializeTransactionVariables() {
        transactionType = transactionType
        amount = transaction.amount * factor
        name = transaction.name
        if name == "unnamed Transaction" {
            name = nil
        }
        category = transaction.category
        if category == "no Category" {
            category = nil
        }
        dateAndTime = transaction.dateAndTime
        repeatTag = transaction.repeatTag
        endRepeat = transaction.endRepeat
        repeatEndDate = transaction.repeatEndDate
    }
    
    private func updateTransaction() {
        if amount != nil {
            amount! *= factor
            name == nil ? name = "unnamed Transaction" : nil
            category == nil ? category = "no Category" : nil
            
            data.database.updateTransaction(
                transaction: Transaction(
                    id: uuid,
                    amount: amount!,
                    name: name!,
                    category: category!,
                    dateAndTime: dateAndTime,
                    repeatTag: repeatTag,
                    endRepeat: endRepeat,
                    repeatEndDate: repeatEndDate
                )
            )
            
            if storeNewCategoriesByDefault && category != "no Category" {
                transactionType ? data.database.insertIncomeCategory(newCategory: category!) : data.database.insertExpenseCategory(newCategory: category!)
            }
            
            data.refreshTransactionGroups()
            data.refreshBalance()
            showingSheet.toggle()
        } else {
            showingAlert.toggle()
        }
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditTransactionView(showingSheet: .constant(true), uuid: .constant(""), repeatUuid: .constant(""), transactionType: .constant(false))
            .environmentObject(Data())
        EditTransactionView(showingSheet: .constant(true), uuid: .constant(""), repeatUuid: .constant(""), transactionType: .constant(false))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
