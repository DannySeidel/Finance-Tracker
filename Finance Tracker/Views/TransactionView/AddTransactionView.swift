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
    @State private var amountTemp: Double?
    @State private var nameTemp: String?
    @State private var categoryTemp: String?
    @State private var dateAndTimeTemp = Date()
    @State private var repeatTagTemp = 0
    @State private var endRepeatTemp = false
    @State private var repeatEndDateTemp = Date()
    
    @State private var transactionTypeTemp = false
    
    var factor: Double {
        transactionTypeTemp ? 1 : -1
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        AmountView(amountTemp: $amountTemp)
                        InfoView(nameTemp: $nameTemp, categroyTemp: $categoryTemp, transactionTypeTemp: $transactionTypeTemp)
                        DateView(dateAndTime: $dateAndTimeTemp, repeatTag: $repeatTagTemp, endRepeat: $endRepeatTemp, repeatEndDate: $repeatEndDateTemp)
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
                                Picker("", selection: $transactionTypeTemp) {
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
                            if (amountTemp != nil) && (nameTemp != nil) && (categoryTemp != nil) {
                                showTransactionSheet.toggle()
                                data.database.insertTransaction(
                                    transaction: Transaction(
                                        amount: amountTemp! * factor,
                                        name: nameTemp!,
                                        category: categoryTemp!,
                                        dateandtime: dateAndTimeTemp,
                                        repeattag: repeatTagTemp,
                                        endrepeat: endRepeatTemp,
                                        repeatenddate: repeatEndDateTemp
                                    )
                                )
                            }
                            data.refreshBalance()
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
