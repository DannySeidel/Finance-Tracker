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
    @State var uuid = ""
    @State var transactionType = false
    
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
                                        onDelete(id: transaction.id)
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
        .sheet(isPresented: $showingSheet) {
            EditTransactionView(showingSheet: $showingSheet, uuid: $uuid, transactionType: $transactionType)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Picker("Filter by \(Image(systemName: "shift"))", selection: $filterTag) {
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
    
    private func onDelete(id: String) {
        data.database.deleteTransaction(uuid: id)
        data.refreshTransactionGroups()
        data.refreshBalance()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView(showingSheet: false)
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
