//
//  TransactionElement.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct TransactionElement: View {
    @EnvironmentObject var data: Data
    @State private var balance = 537.93
    
    var transaction: DataStructure

    var amountcolor: Color {
        transaction.amount > 0 ?
        Color(red: 35/255, green: 310/255, blue: 139/255) :
        Color(red: 240/255, green: 60/255, blue: 25/255)
    }    
    
    var body: some View {
        VStack {
            HStack {
                Text(transaction.dateandtime, style: .date)
                
                Spacer()
            }
            .padding(.leading)
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
                        Text(transaction.dateandtime, style: .time)
                        
                        Spacer()
                        
                        Text(String(balance))
                    }
                    .foregroundColor(Color(.systemGray))
                }
                .padding()
            }
        }
        .padding()
    }
}

struct TransactionElement_Previews: PreviewProvider {
    static var previews: some View {
        TransactionElement(transaction: DataStructure(amount: -9.11, name: "Lunch", category: "", dateandtime: Date.now, repeattag: 0, endrepeat: false, repeatenddate: Date.now))
            .preferredColorScheme(.dark)
            .frame(width: 400, height: 100)
    }
}
