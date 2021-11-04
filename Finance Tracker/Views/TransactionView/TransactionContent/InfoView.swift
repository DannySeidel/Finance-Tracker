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
    
    @State private var nametemp: String?
    @State private var categroytemp: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            VStack {
                HStack {
                    Text("Name")
                    TextField("Lunch", text: $nametemp.bound)
                    NavigationLink(destination: NameSelectView()) {
                        Image(systemName: "plus")
                    }
                }
                Divider()
                HStack {
                    Text("Category")
                    TextField("Food", text: $categroytemp.bound)
                    NavigationLink(destination: CategorySelectView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding()
        }
        .padding()
    }
    func saveinfo() {
        if let nametemp = self.nametemp {
            data.name.append(nametemp)
        }
        if let categroytemp = self.categroytemp {
            data.category.append(categroytemp)
        }
        emptyinfo()
    }
    func emptyinfo() {
        nametemp = ""
        categroytemp = nil
    }
}

struct TransactionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .previewLayout(.fixed(width: 400, height: 150))
            .preferredColorScheme(.dark)
    }
}
