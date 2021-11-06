//
//  NameSelectView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct Name: Identifiable {
    let id = UUID()
    let title: String
}

struct NameElementView: View {
    var name: Name
    @Binding var nametemp: String?
    
    var body: some View {
        Button(name.title) {
            nametemp = name.title
        }
        .navigationTitle("Select Name")
    }
}

struct NameSelectView: View {
    @Binding var nametemp: String?
    
    let names = [
        Name(title: "1"),
        Name(title: "2")
    ]
    
    var body: some View {
        List {
            ForEach(names) { name in
                NameElementView(name: name, nametemp: $nametemp)
            }
        }
    }
}

struct NameSelectView_Previews: PreviewProvider {
    static var previews: some View {
        NameSelectView(nametemp: .constant(""))
    }
}
