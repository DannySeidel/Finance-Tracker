//
//  TransactionNameView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

struct InfoView: View {
    @EnvironmentObject var data: Data
    
    @Binding var nametemp: String?
    @Binding var categroytemp: String?
    @Binding var transactiontypetemp: Bool
    
    
    
    let names = ["1", "2"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            VStack {
                HStack {
                    Text("Name")
                    TextField("Lunch", text: $nametemp.bound)
                    NavigationLink(destination: NameSelectView(nametemp: $nametemp)) {
                        Image(systemName: "shift.fill")
                            .rotationEffect(.degrees(90))
                    }
                }
                Divider()
                HStack {
                    Text("Category")
                    TextField("Food & Drinks", text: $categroytemp.bound)
                    NavigationLink(destination: CategorySelectView(categroytemp: $categroytemp, transactiontypetemp: $transactiontypetemp)) {
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
        InfoView(nametemp: .constant(""), categroytemp: .constant(""), transactiontypetemp: .constant(false))
            .previewLayout(.fixed(width: 400, height: 150))
            .preferredColorScheme(.dark)
    }
}
