//
//  BalanceView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct BalanceView: View {
    @EnvironmentObject var data: Data
    
    var monthlyBalance: Double {
        data.transactions.map({$0.amount}).reduce(0, +)
    }
    
    var factor: Double {
        monthlyBalance < 0 ? -1 : 1
    }
    
    var rotation: Double {
        monthlyBalance > 0 ? 0 : 180
    }
    
    var balanceColor: Color {
        if monthlyBalance > 0 {
            return Color(red: 35/255, green: 310/255, blue: 139/255)
        } else if monthlyBalance < 0 {
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
                if monthlyBalance != 0 {
                    Image(systemName: "shift.fill")
                        .rotationEffect(.degrees(rotation))
                }
                Text(String(monthlyBalance * factor))
                    .bold()
                Image(systemName: "eurosign.circle")
                
            }
            .font(.system(size: 42))
            .foregroundColor(balanceColor)
        }
        .frame(height: 125)
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
