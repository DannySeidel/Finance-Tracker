//
//  TransactionContentView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct TransactionContentView: View {
    var body: some View {
        VStack {
            AmountView()
            InfoView()
            DateView()
            MapView()
        }
    }
}

struct TransactionContentView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionContentView()
    }
}
