//
//  TransactionNameView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI


struct InfoView: View {
    @EnvironmentObject var data: Data
    
    @Binding var nameTemp: String?
    @Binding var categroyTemp: String?
    @Binding var transactionTypeTemp: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppSheetElement")!))
            VStack {
                HStack {
                    Text("Name")
                    TextField("Lunch", text: $nameTemp.bound)
                    NavigationLink(destination: NameSelectView(nameTemp: $nameTemp)) {
                        Image(systemName: "shift.fill")
                            .rotationEffect(.degrees(90))
                    }
                }
                Divider()
                HStack {
                    Text("Category")
                    TextField("Food & Drinks", text: $categroyTemp.bound)
                    NavigationLink(destination: CategorySelectView(categroyTemp: $categroyTemp, transactionTypeTemp: $transactionTypeTemp)) {
                        Image(systemName: "shift.fill")
                            .rotationEffect(.degrees(90))
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(nameTemp: .constant(""), categroyTemp: .constant(""), transactionTypeTemp: .constant(false))
            .previewLayout(.fixed(width: 400, height: 120))
            .background(Color.init(UIColor(named: "AppBackground")!))
        InfoView(nameTemp: .constant(""), categroyTemp: .constant(""), transactionTypeTemp: .constant(false))
            .previewLayout(.fixed(width: 400, height: 120))
            .preferredColorScheme(.dark)
    }
}
