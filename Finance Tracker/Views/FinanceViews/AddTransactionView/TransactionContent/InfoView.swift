//
//  TransactionNameView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct InfoView: View {
    @State private var name: String = ""
    @State private var categroy: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            VStack {
                HStack {
                    Text("Name")
                    TextField("", text: $name)
                }
                Divider()
                HStack {
                    Text("Category")
                    TextField("", text: $categroy)
                }
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
