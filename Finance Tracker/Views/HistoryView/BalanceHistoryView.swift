//
//  BalanceHistoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 17.12.21.
//

import SwiftUI

struct BalanceHistoryView: View {
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
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color(.systemGray6))
            HStack {
                if data.balance != 0 {
                    Image(systemName: "shift.fill")
                        .rotationEffect(.degrees(rotation))
                }
                Text(String(format: "%.2f", data.balance * factor))
                    .bold()
                Image(systemName: "eurosign.circle")
            }
            .font(.system(size: 32))
            .foregroundColor(balanceColor)
        }
    }
}

struct BalanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceHistoryView()
    }
}
