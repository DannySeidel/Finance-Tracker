//
//  EditTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 15.12.21.
//

import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var data: Data
    
    @State private var amountTemp: Double?
    @State private var nameTemp: String?
    @State private var categoryTemp: String?
    @State private var dateAndTimeTemp = Date()
    @State private var repeatTagTemp = 0
    @State private var endRepeatTemp = false
    @State private var repeatEndDateTemp = Date()
    
    @Binding var showingSheet: Bool
    @Binding var uuid: String
    @Binding var transactionType: Bool
    
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
                        AmountView(amountTemp: $amountTemp)
                        InfoView(nameTemp: $nameTemp, categroyTemp: $categoryTemp, transactionTypeTemp: $transactionType)
                        DateView(dateAndTime: $dateAndTimeTemp, repeatTag: $repeatTagTemp, endRepeat: $endRepeatTemp, repeatEndDate: $repeatEndDateTemp)
                        MapView()
                    }
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
                            data.database.updateTransaction(
                                transaction: Transaction(
                                    id: uuid,
                                    amount: amountTemp! * factor,
                                    name: nameTemp!,
                                    category: categoryTemp!,
                                    dateAndTime: dateAndTimeTemp,
                                    repeatTag: repeatTagTemp,
                                    endRepeat: endRepeatTemp,
                                    repeatEndDate: repeatEndDateTemp
                                )
                            )
                            if storeNewCategoriesByDefault {
                                transactionType ? data.database.insertIncomeCategory(newCategory: categoryTemp!) : data.database.insertExpenseCategory(newCategory: categoryTemp!)
                            }
                            data.refreshTransactionGroups()
                            data.refreshBalance()
                            showingSheet.toggle()
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
            .onAppear(perform: {
                transactionType = transactionType
                amountTemp = transaction.amount * factor
                nameTemp = transaction.name
                categoryTemp = transaction.category
                dateAndTimeTemp = transaction.dateAndTime
                repeatTagTemp = transaction.repeatTag
                endRepeatTemp = transaction.endRepeat
                repeatEndDateTemp = transaction.repeatEndDate
            })
        }
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditTransactionView(showingSheet: .constant(true), uuid: .constant(""), transactionType: .constant(false))
    }
}
