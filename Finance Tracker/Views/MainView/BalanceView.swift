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
            return Color.init(UIColor(named: "AppGreen")!)
        } else if data.balance < 0 {
            return Color.init(UIColor(named: "AppRed")!)
        } else {
            return Color.init(UIColor(named: "AppTextGray")!)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppElement")!))
            NavigationLink(destination: HistoryView()) {
                if data.balance != 0 {
                    Image(systemName: "shift.fill")
                        .rotationEffect(.degrees(rotation))
                }
                Text(String(format: "%.2f", data.balance * factor))
                    .bold()
                Image(systemName: "eurosign.circle")
            }
            .font(.system(size: 42))
            .foregroundColor(balanceColor)
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
            .previewLayout(.fixed(width: 400, height: 140))
            .environmentObject(Data())
            .background(Color.init(UIColor(named: "AppBackground")!))
        BalanceView()
            .previewLayout(.fixed(width: 400, height: 140))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
