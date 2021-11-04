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
//        ForEach(data) { element in
//            TransactionElement(data: data)
//    }
        TransactionElement()
            .frame(height: 80)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(Data())
    }
}
