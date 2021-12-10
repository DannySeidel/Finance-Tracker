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
    
    var transactionDateGroups: [[Transaction]] {
        var groups: [[Transaction]] = []
        for transaction in data.database.loadAllTransactions() {
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
    
    var sortedgroups: [[Transaction]] {
        var sortResult: [[Transaction]] = []
        for group in transactionDateGroups.sorted(by: {$0.first!.dateandtime>$1.first!.dateandtime}) {
            sortResult.append(group.sorted(by: {$0.dateandtime>$1.dateandtime}))
        }
        return sortResult
    }
    
    var searchgroups: [[Transaction]] {
        var searchResult: [[Transaction]] = []
        if transactionSearchName.isEmpty {
            searchResult = sortedgroups
        } else {
            sortedgroups.forEach { group in
                searchResult.append(group.filter({$0.name.contains(transactionSearchName)}))
            }
        }
        return searchResult
    }
    
    var body: some View {
        ScrollView {
            ForEach(searchgroups, id: \.first?.id) { group in
                if group.first != nil {
                    VStack {
                        HStack {
                            Text(group.first!.dateandtime, style: .date)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        ForEach(group, id: \.id) { transaction in
                            TransactionElement(transaction: transaction)
                                .frame(height: 70)
                        }
                    }
                    .padding(.top)
                }
            }
            .searchable(text: $transactionSearchName, placement: .navigationBarDrawer(displayMode: .always))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Picker("Filter by \(Image(systemName: "shift"))", selection: $filterTag) {
                    Text("Name").tag(0)
                    Text("Amount").tag(1)
                    Text("Date").tag(2)
                }
                .pickerStyle(MenuPickerStyle())
        )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
