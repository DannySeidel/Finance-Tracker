//
//  TransactionDateView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct DateView: View {
    @State private var transactionDateandTime = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(Color(.systemGray5))
                VStack {
                    HStack {
                        Text("Date")
                        DatePicker(selection: $transactionDateandTime, in: ...Date()) {
                            
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    NavigationLink(destination: DateRepeatView()) {
                        HStack {
                            Text("Repeat")
                            
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
            .padding()
            
        }
    }
}

struct TransactionDateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView()
    }
}
