//
//  NameSelectView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct NameElementView: View {
    @EnvironmentObject var data: Data
    @Environment(\.presentationMode) var presentationMode
    @Binding var nameTemp: String?
    
    var name: String
    
    var body: some View {
        Button(name) {
            nameTemp = name
            presentationMode.wrappedValue.dismiss()
        }
        .navigationTitle("Select Name")
        .foregroundColor(Color(.white))
    }
}

struct NameSelectView: View {
    @EnvironmentObject var data: Data
    @Binding var nameTemp: String?
    @State private var searchText = ""
    
    var searchNames: [String] {
        if searchText.isEmpty {
            return data.names.sorted(by: {$0<$1})
        } else {
            return data.names.filter { $0.contains(searchText) }.sorted(by: {$0<$1})
        }
    }
    
    var body: some View {
        List(searchNames, id: \.self) { name in
            NameElementView(nameTemp: $nameTemp, name: name)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct NameSelectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NameSelectView(nameTemp: .constant(""))
                .environmentObject(Data())
                .preferredColorScheme(.dark)            
        }
    }
}
