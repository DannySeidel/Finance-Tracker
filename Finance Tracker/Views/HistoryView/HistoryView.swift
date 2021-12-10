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
        transactionDateGroups.sorted(by: {$0.first!.dateandtime>$1.first!.dateandtime})
    }
    
//    var searchgroup: [[DataStructure]] {
//        sortedgroups.compactMap { group in
//            group.filter()
//        }
//    }
    
// sort
//    map
    
    var body: some View {
        ScrollView {
            ForEach(sortedgroups, id: \.first?.id) { group in
                if transactionSearchName.isEmpty {
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
                } else {
                    let searchgroup = group.filter { $0.name.contains(transactionSearchName) }
                    if searchgroup.first != nil {
                        VStack {
                            HStack {
                                Text(searchgroup.first!.dateandtime, style: .date)
                                
                                Spacer()
                            }
                            .padding(.leading)
                            ForEach(searchgroup, id: \.id) { transaction in
                                TransactionElement(transaction: transaction)
                                    .frame(height: 70)
                            }
                        }
                        .padding(.top)
                    }
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
