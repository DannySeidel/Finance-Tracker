//
//  HistoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 02.11.21.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var data: Data
    
//    var transactionDateGroups: [[DataStructure]] {
//        var groups: [[DataStructure]] = []
//
//        for transaction in data.transactions {
//            for group in groups {
//                if groups.first?.dateandtime == transaction.dateandtime {
//                    //if group with transaction date exists add to group
//                    group.append(contentsOf: transaction.dateandtime)
//                } else {
//                    // else create group
//                    //groups.append(contentsOf: transaction.dateandtime)
//                }
//            }
//        }
//        return groups
//    }
    
    var sortedtransactions: [DataStructure] {
        data.transactions.sorted(by: {$0.dateandtime>$1.dateandtime})
    }
    
    var body: some View {
        ScrollView {
            ForEach(sortedtransactions) { transaction in
                TransactionElement(transaction: transaction)
                    .frame(height: 130)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
