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
    
    var transactionDateGroups: [[DataStructure]] {
        var groups: [[DataStructure]] = []

        for transaction in data.transactions {
            var groupexists = false
            for group in groups {
                if let firstGroup = group.first, Calendar.current.isDate(
                    firstGroup.dateandtime, inSameDayAs: transaction.dateandtime
                ) {
                    let groupIndex = groups.firstIndex(of: group)!
                    var newGroup = groups[groupIndex]
                    newGroup.append(transaction)
                    groups[groupIndex] = newGroup
                    groupexists = true
                }
            }
            if !groupexists {
                groups.append([transaction])
            }
        }
        return groups
    }
    
    var sortedgroups: [[DataStructure]] {
        transactionDateGroups.sorted(by: {$0.first!.dateandtime>$1.first!.dateandtime})
    }
    
    var body: some View {
        ScrollView {
            ForEach(sortedgroups, id: \.first?.id) { groups in
                VStack {
                    HStack {
                        Text(groups.first!.dateandtime, style: .date)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    ForEach(groups, id: \.id) { transaction in
                        TransactionElement(transaction: transaction)
                            .frame(height: 70)
                    }
                }
                .padding(.top)
            }
            .searchable(text: $transactionSearchName, placement: .navigationBarDrawer(displayMode: .always))
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
