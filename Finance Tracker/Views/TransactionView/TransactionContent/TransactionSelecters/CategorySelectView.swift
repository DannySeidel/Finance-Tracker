//
//  CategorySelectView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let title: String
}

struct CategoryElementView: View {
    @EnvironmentObject var data: Data
    @Environment(\.presentationMode) var presentationMode
    @Binding var categroytemp: String?
    
    var category: String
    
    var body: some View {
        Button(category) {
            categroytemp = category
            presentationMode.wrappedValue.dismiss()
        }
        .navigationTitle("Select Category")
        .foregroundColor(Color(.white))
    }
}

struct CategorySelectView: View {
    @EnvironmentObject var data: Data
    @Binding var categroytemp: String?
    @Binding var transactiontypetemp: Bool
    @State private var searchText = ""
    
    var searchCategories: [String] {
        if searchText.isEmpty {
            return transactiontypetemp ? data.categoriesplus : data.categoriesminus
        } else {
            return transactiontypetemp ?
            data.categoriesplus.filter { $0.contains(searchText) } :
            data.categoriesminus.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        List(searchCategories, id: \.self) { category in
            CategoryElementView(categroytemp: $categroytemp, category: category)
        }
        .searchable(text: $searchText)
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(categroytemp: .constant(""), transactiontypetemp: .constant(false))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
