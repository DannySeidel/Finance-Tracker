//
//  TransactionAmountView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AmountView: View {
    @EnvironmentObject var data: Data
    @Binding var amounttemp: Double?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            HStack {
                Text("Amount")
                TextField("9,11", value: $amounttemp, format: .number)
                    .keyboardType(.decimalPad)
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionAmountView_Previews: PreviewProvider {
    static var previews: some View {
        AmountView(amounttemp: .constant(9.11))
            .environmentObject(Data())
            .previewLayout(.fixed(width: 400, height: 100))
            .preferredColorScheme(.dark)
    }
}
