//
//  BalanceView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct BalanceView: View {
    var body: some View {
        ZStack {
            Capsule(style: .continuous)
            HStack {
                Image(systemName: "plus")
                Text("1587,24")
                    .bold()
                Image(systemName: "eurosign.circle")
                
            }
            .font(.system(size: 48))
            .foregroundColor(Color(red: 35/255, green: 310/255, blue: 139/255))
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
