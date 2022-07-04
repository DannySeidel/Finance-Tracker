//
//  HistoryContentView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 04.07.22.
//

import SwiftUI

struct HistoryContentView: View {
    @EnvironmentObject var data: Data
    @Binding var transactionSearchName: String
    @Binding var showingSheet: Bool
    @Binding var showingConfirmationDialog: Bool
    @Binding var uuid: String
    @Binding var repeatUuid: String
    @Binding var dateAndTime: Date
    @Binding var transactionType: Bool
    @Binding var confirmationType: String
    
    var searchGroups: [[HistoryTransaction]] {
        if transactionSearchName.isEmpty {
            return data.transactionGroups
        } else {
            return data.transactionGroups.map { group in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy"
                return group.filter({
                    $0.category.contains(transactionSearchName) ||
                    String($0.amount).contains(transactionSearchName) ||
                    dateFormatter.string(from: $0.dateAndTime).contains(transactionSearchName) ||
                    $0.name.contains(transactionSearchName)
                }
                )
            }
        }
    }
    
    var body: some View {
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
    }
    
    private func getconfirmationType(repeatId: String) {
        let repeatingTransactionCount = data.database.getTransactionsFromRepeatId(repeatUuid: repeatId).count
        
        if repeatingTransactionCount <= 1 {
            confirmationType = "Single"
        } else {
            confirmationType = "Repeating"
        }
    }
}

struct HistoryContentView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryContentView(transactionSearchName: .constant(""), showingSheet: .constant(false), showingConfirmationDialog: .constant(false), uuid: .constant("4893a086-912d-4c3c-a3a4-8e2d711ea08c"), repeatUuid: .constant("52d093b7-df48-494a-9497-aa9e4cf1f89a"), dateAndTime: .constant(Date()), transactionType: .constant(false), confirmationType: .constant(""))
            .environmentObject(Data())
    }
}
