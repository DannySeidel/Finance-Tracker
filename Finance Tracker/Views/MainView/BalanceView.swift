//
//  BalanceView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct BalanceView: View {
    @EnvironmentObject var data: Data
    
    var monthlybalance: Double {
        data.transactions.map({$0.amount}).reduce(0, +)
    }
    
    var arrow: String {
        if monthlybalance > 0 {
            return "arrow.up"
        } else if monthlybalance < 0 {
            return "arrow.down"
        } else {
            return ""
        }
    }
    
    var balancecolor: Color {
        if monthlybalance > 0 {
            return Color(red: 35/255, green: 310/255, blue: 139/255)
        } else if monthlybalance < 0 {
            return Color(red: 240/255, green: 60/255, blue: 25/255)
        } else {
            return Color(.systemGray)
        }
    }
    
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .foregroundColor(Color(.systemGray6))
            NavigationLink(destination: HistoryView()) {
                Image(systemName: arrow)
                Text(String(monthlybalance))
                    .bold()
                Image(systemName: "eurosign.circle")
                
            }
            .font(.system(size: 42))
            .foregroundColor(balancecolor)
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
            .previewLayout(.fixed(width: 400, height: 150))
            .preferredColorScheme(.dark)
            .environmentObject(Data())
    }
}