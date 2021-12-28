//
//  TransactionElement.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct TransactionElement: View {
    @EnvironmentObject var data: Data
    
    var transaction: HistoryTransaction
    
    var amountcolor: Color {
        transaction.amount > 0 ?
        Color.init(UIColor(named: "AppGreen")!) :
        Color.init(UIColor(named: "AppRed")!)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppElement")!))
            VStack {
                HStack {
                    Text(transaction.name)
                    
                    Spacer()
                    
                    Text(String(format: "%.2f", transaction.amount) + "€")
                        .foregroundColor(amountcolor)
                }
                HStack {
                    Text(transaction.category)
                    
                    Spacer()
                    
                    Text(transaction.dateAndTime, style: .time)
                }
                .foregroundColor(Color.init(UIColor(named: "AppTextGray")!))
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
            Spacer()
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "Food", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
                .frame(width: 400, height: 75)
            TransactionElement(transaction: HistoryTransaction(id: "53ef26c9-009b-4b41-ba66-99405bf775d9", amount: -15.73, name: "Dinner", category: "Restaurant", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
                .environmentObject(Data())
                .frame(width: 400, height: 75)
            Spacer()
        }
        .background(Color.init(UIColor(named: "AppBackground")!))
        VStack {
            TransactionElement(transaction: HistoryTransaction(id: "1959addc-387b-437c-87d2-776a40e9f509", amount: 9.11, name: "Lunch", category: "Food", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
                .frame(width: 400, height: 75)
            TransactionElement(transaction: HistoryTransaction(id: "53ef26c9-009b-4b41-ba66-99405bf775d9", amount: -15.73, name: "Dinner", category: "Restaurant", dateAndTime: Date.now, repeatTag: 0, repeatId: ""))
                .environmentObject(Data())
                .frame(width: 400, height: 75)
                .preferredColorScheme(.dark)
        }
    }
}
