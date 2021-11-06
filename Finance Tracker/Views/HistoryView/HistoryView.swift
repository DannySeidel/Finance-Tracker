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
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                TransactionElement(transaction: transaction)
            }
        }
        
        Text("filler")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
