//
//  TransactionAmountView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AmountView: View {
    @State private var amount: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            HStack {
                Text("Amount")
                TextField("", text: $amount)
                    .keyboardType(.numberPad)
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionAmountView_Previews: PreviewProvider {
    static var previews: some View {
        AmountView()
    }
}
