//
//  TransactionElement.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct TransactionElement: View {
    @EnvironmentObject var data: Data
    
    var transaction: Transaction
    
//    var balance: Double {
//        let filteredData = data.transactions.filter { transaction.dateandtime >= $0.dateandtime }
//        return filteredData.map({$0.amount}).reduce(0, +)
//    }
    
    var amountcolor: Color {
        transaction.amount > 0 ?
        Color(red: 35/255, green: 310/255, blue: 139/255) :
        Color(red: 240/255, green: 60/255, blue: 25/255)
    }
    
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
                    Text(transaction.category)
                    
                    Spacer()
                    
                    Text(transaction.dateandtime, style: .time)
                }
                .foregroundColor(Color(.systemGray))
            }
            .padding()
        }
        .padding(.leading)
        .padding(.trailing)
    }
}

struct TransactionElement_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionElement(transaction: Transaction(amount: 9.11, name: "Lunch", category: "", dateandtime: Date.now, repeattag: 0, endrepeat: false, repeatenddate: Date.now))
                .environmentObject(Data())
                .preferredColorScheme(.dark)
                .frame(width: 400, height: 75)
            TransactionElement(transaction: Transaction(amount: -15.73, name: "Dinner", category: "", dateandtime: Date.now, repeattag: 0, endrepeat: false, repeatenddate: Date.now))
                .environmentObject(Data())
                .preferredColorScheme(.dark)
                .frame(width: 400, height: 75)
        }
    }
}
