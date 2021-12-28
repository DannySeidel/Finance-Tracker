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
    
    var searchGroups: [[HistoryTransaction]] {
        if transactionSearchName.isEmpty {
            return data.transactionGroups
        } else {
            return data.transactionGroups.map { group in
                switch filterTag {
                case 1:
                    return group.filter({$0.category.contains(transactionSearchName)})
                case 2:
                    return group.filter({String($0.amount).contains(transactionSearchName)})
                case 3:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yy"
                    return group.filter({dateFormatter.string(from: $0.dateAndTime).contains(transactionSearchName)})
                default:
                    return group.filter({$0.name.contains(transactionSearchName)})
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            BalanceHistoryView()
                .frame(height: 60)
                .padding(.leading)
                .padding(.trailing)
            ScrollView {
                ForEach(searchGroups, id: \.first?.id) { group in
                    if group.first != nil {
                        VStack {
                            HStack {
                                Text(group.first!.dateAndTime, style: .date)
                                
                                Spacer()
                            }
                            .padding(.leading, 30)
                            ForEach(group, id: \.id) { transaction in
                                TransactionElement(transaction: transaction)
                                    .frame(height: 70)
                                    .contextMenu {
                                        Button {
                                            showingSheet.toggle()
                                            uuid = transaction.id
                                            if transaction.amount < 0 {
                                                transactionType = false
                                            } else {
                                                transactionType = true
                                            }
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) {
                                            uuid = transaction.id
                                            repeatUuid = transaction.repeatId
                                            dateAndTime = transaction.dateAndTime
                                            getconfirmationType(repeatId: repeatUuid)
                                            showingConfirmationDialog.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.top)
                    }
                }
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
            .navigationBarItems(
                trailing:
                    HStack {
                        Spacer()
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Picker("\(Image(systemName: "line.3.horizontal.decrease.circle"))", selection: $filterTag) {
                            Text("Name").tag(0)
                            Text("Category").tag(1)
                            Text("Amount").tag(2)
                            Text("Date").tag(3)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .offset(y: 1)
                    }
            )
        }
        .background(Color.init(UIColor(named: "AppBackground")!))
    }
    
    private func getconfirmationType(repeatId: String) {
        let repeatingTransactionCount = data.database.getTransactionsFromRepeatId(repeatUuid: repeatId).count
        
        if repeatingTransactionCount <= 1 {
            confirmationType = "Single"
        } else {
            confirmationType = "Repeating"
        }
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
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
        }
        NavigationView {
            HistoryView(showingSheet: false)
                .environmentObject(Data())
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
        }
        .preferredColorScheme(.dark)
    }
}
