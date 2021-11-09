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
    
    var amountcolor: Color {
        if transaction.amount > 0 {
            return Color(red: 35/255, green: 310/255, blue: 139/255)
        } else {
            return Color(red: 240/255, green: 60/255, blue: 25/255)
        }
    }
    
    var transaction: DataStructure
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color(.systemGray6))
            VStack {
                HStack {
                    Text(transaction.name)
                    
                    Spacer()
                    
                    Text(String(transaction.amount))
                        .foregroundColor(amountcolor)
                }
                HStack {
                    Text(time)
                    
                    Spacer()
                    
                    Text(String(balance))
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
        TransactionElement(transaction: DataStructure(id: 0, amount: -9.11, name: "Lunch", category: "", dateandtime: Date.now, repeattag: 0, endrepeat: false, repeatenddate: Date.now))
            .preferredColorScheme(.dark)
            .frame(width: 400, height: 100)
    }
}
