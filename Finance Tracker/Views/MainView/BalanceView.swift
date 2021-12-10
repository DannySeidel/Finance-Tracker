//
//  BalanceView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct BalanceView: View {
    @EnvironmentObject var data: Data
    
    var factor: Double {
        data.balance < 0 ? -1 : 1
    }
    
    var rotation: Double {
        data.balance > 0 ? 0 : 180
    }
    
    var balanceColor: Color {
        if data.balance > 0 {
            return Color(red: 35/255, green: 310/255, blue: 139/255)
        } else if data.balance < 0 {
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
                if data.balance != 0 {
                    Image(systemName: "shift.fill")
                        .rotationEffect(.degrees(rotation))
                }
                Text(String(data.balance * factor))
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
