//
//  TransactionAmountView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AmountView: View {
    @EnvironmentObject var data: Data
    @Binding var amountTemp: Double?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppElement")!))
            HStack {
                Text("Amount")
                TextField("9,11", value: $amountTemp, format: .number)
                    .keyboardType(.decimalPad)
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionAmountView_Previews: PreviewProvider {
    static var previews: some View {
        AmountView(amountTemp: .constant(9.11))
            .environmentObject(Data())
            .previewLayout(.fixed(width: 400, height: 100))
            .background(Color.init(UIColor(named: "AppBackground")!))
        AmountView(amountTemp: .constant(9.11))
            .environmentObject(Data())
            .previewLayout(.fixed(width: 400, height: 100))
            .preferredColorScheme(.dark)
    }
}
