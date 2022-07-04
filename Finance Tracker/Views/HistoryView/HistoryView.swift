//
//  HistoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 02.11.21.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var data: Data
    @State var transactionSearchName = ""
    @State var filterTag = 0
    @State var showingSheet = false
    @State var showingConfirmationDialog = false
    @State var uuid = ""
    @State var repeatUuid = ""
    @State var dateAndTime = Date()
    @State var transactionType = false
    @State var confirmationType = ""
    
    var body: some View {
        VStack {
            BalanceHistoryView()
                .frame(height: 60)
                .padding(.leading)
                .padding(.trailing)
            ScrollView {
                HistoryContentView(transactionSearchName: $transactionSearchName, showingSheet: $showingSheet, showingConfirmationDialog: $showingConfirmationDialog, uuid: $uuid, repeatUuid: $repeatUuid, dateAndTime: $dateAndTime, transactionType: $transactionType, confirmationType: $confirmationType)
                .searchable(text: $transactionSearchName, placement: .navigationBarDrawer(displayMode: .always))
            }
            .confirmationDialog("This is a \(confirmationType) Transaction", isPresented: $showingConfirmationDialog, titleVisibility: .visible) {
                if confirmationType == "Repeating" {
                    Button("Delete All Future Transactions", role: .destructive) {
                        deleteAllFutureTransactions(repeatId: repeatUuid, dateAndTime: dateAndTime)
                    }
                }
                Button("Delete This Transaction", role: .destructive) {
                    deleteCurrentTransaction(id: uuid)
                }
            }
            .sheet(isPresented: $showingSheet) {
                EditTransactionView(showingSheet: $showingSheet, uuid: $uuid, repeatUuid: $repeatUuid, transactionType: $transactionType)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.init(UIColor(named: "AppBackground")!))
    }
    
    private func deleteCurrentTransaction(id: String) {
        data.database.deleteTransaction(uuid: id)
        data.refreshTransactionGroups()
        data.refreshBalance()
    }
    
    private func deleteAllFutureTransactions(repeatId: String, dateAndTime: Date) {
        data.database.deleteFutureTransactions(uuid: repeatId, date: dateAndTime)
        if confirmationType == "Single" {
            data.database.deleteRepeatingTransaction(uuid: repeatId)
        }
        data.refreshTransactionGroups()
        data.refreshBalance()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView(showingSheet: false)
                .environmentObject(Data())
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "", dateAndTime: Date.now, repeatId: ""))
        }
        NavigationView {
            HistoryView(showingSheet: false)
                .environmentObject(Data())
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "", dateAndTime: Date.now, repeatId: ""))
        }
        .preferredColorScheme(.dark)
    }
}
