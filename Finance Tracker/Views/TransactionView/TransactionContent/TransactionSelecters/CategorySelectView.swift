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
    var category: Category
    @Environment(\.presentationMode) var presentationMode
    @Binding var categroytemp: String?
    
    var body: some View {
        Button(category.title) {
            categroytemp = category.title
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
    
    var categories: [Category] {
        transactiontypetemp ? data.categoriesplus : data.categoriesminus
    }
    
    var sortedCategories: [Category] {
        categories.sorted(by: {$0.title<$1.title})
    }
    
    var body: some View {
        List(categories) { category in
            CategoryElementView(category: category, categroytemp: $categroytemp)
            
        }
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(categroytemp: .constant(""), transactiontypetemp: .constant(false))
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
