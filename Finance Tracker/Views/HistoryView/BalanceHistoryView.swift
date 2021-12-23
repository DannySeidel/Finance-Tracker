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
            return Color.init(UIColor(named: "AppGreen")!)
        } else if data.balance < 0 {
            return Color.init(UIColor(named: "AppRed")!)
        } else {
            return Color.init(UIColor(named: "AppTextGray")!)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppElement")!))
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
            .environmentObject(Data())
            .previewLayout(.fixed(width: 400, height: 60))
        BalanceHistoryView()
            .environmentObject(Data())
            .previewLayout(.fixed(width: 400, height: 60))
            .preferredColorScheme(.dark)
    }
}
