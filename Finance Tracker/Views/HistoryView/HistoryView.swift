//
//  HistoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 02.11.21.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var data: Data
    
    var body: some View {
        ForEach(data.transactions) { transaction in
                TransactionElement(transaction: transaction)
                .frame(height: 65)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
