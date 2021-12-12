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
    
    var transactionDateGroups: [[HistoryTransaction]] {
        var groups: [[HistoryTransaction]] = []
        for transaction in data.database.getTransactionsForHistory() {
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
    
    var sortedgroups: [[HistoryTransaction]] {
        return transactionDateGroups.map { group in
            group.sorted(by: {$0.dateandtime>$1.dateandtime})
        }
    }
    
    var searchgroups: [[HistoryTransaction]] {
        if transactionSearchName.isEmpty {
            return sortedgroups
        } else {
            return sortedgroups.map { group in
                switch filterTag {
                case 1:
                    return group.filter({$0.category.contains(transactionSearchName)})
                case 2:
                    return group.filter({String($0.amount).contains(transactionSearchName)})
                case 3:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yy"
                    return group.filter({dateFormatter.string(from: $0.dateandtime).contains(transactionSearchName)})
                default:
                    return group.filter({$0.name.contains(transactionSearchName)})
                }
            }
        }
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
                        .padding(.leading, 30)
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
                    Text("Category").tag(1)
                    Text("Amount").tag(2)
                    Text("Date").tag(3)
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
