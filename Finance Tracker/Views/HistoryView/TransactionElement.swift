//
//  TransactionElement.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct TransactionElement: View {
    @EnvironmentObject var data: Data
    @State private var time = "13:24"
    @State private var balance = 537.93
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color(.systemGray6))
            VStack {
                HStack {
//                    Text(data.name)
                    
                    Spacer()
                    
//                    Text(data.amount)
                }
                HStack {
                    Text("\(time)")
                    
                    Spacer()
                    
                    Text("\(balance)")
                }
                .foregroundColor(Color(.systemGray))
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionElement_Previews: PreviewProvider {
    static var previews: some View {
        TransactionElement()
            .preferredColorScheme(.dark)
            .frame(width: 400, height: 100)
    }
}
