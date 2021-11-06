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
    
    var body: some View {
        Text(category.title)
    }
}

struct CategorySelectView: View {
    @Binding var categroytemp: String?
    
    let categories = [
        Category(title: "1"),
        Category(title: "2")
    ]
    
    var body: some View {
        List(categories) { category in
            CategoryElementView(category: category)
            
        }
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(categroytemp: .constant(""))
    }
}
