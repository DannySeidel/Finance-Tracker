//
//  CategorySelectView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 03.11.21.
//

import SwiftUI

struct CategoryElementView: View {
    @EnvironmentObject var data: Data
    @Environment(\.presentationMode) var presentationMode
    @Binding var categroyTemp: String?
    
    var category: String
    
    var body: some View {
        Button(category) {
            categroyTemp = category
            presentationMode.wrappedValue.dismiss()
        }
        .navigationTitle("Select Category")
        .foregroundColor(Color(.white))
    }
}

struct CategorySelectView: View {
    @EnvironmentObject var data: Data
    @Binding var categroyTemp: String?
    @Binding var transactionTypeTemp: Bool
    @State private var searchText = ""
    
    var searchCategories: [Category] {
        if searchText.isEmpty {
            return transactionTypeTemp ?
            data.database.getPlusCategories() :
            data.database.getMinusCategories()
        } else {
            return transactionTypeTemp ?
            data.database.getPlusCategories().filter { $0.name.contains(searchText) } :
            data.database.getMinusCategories().filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        List(searchCategories, id: \.self) { category in
            CategoryElementView(categroyTemp: $categroyTemp, category: category.name)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategorySelectView(categroyTemp: .constant(""), transactionTypeTemp: .constant(false))
                .environmentObject(Data())
                .preferredColorScheme(.dark)            
        }
    }
}
