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
    @Binding var categroytemp: String?
    
    var body: some View {
        Button(category.title) {
            categroytemp = category.title
        }
        .navigationTitle("Select Category")
        .foregroundColor(Color(.white))
    }
}

struct CategorySelectView: View {
    @Binding var categroytemp: String?
    @Binding var transactiontypetemp: Bool
    
    var categories: [Category] {
        transactiontypetemp ? categoriesplus : categoriesminus
    }
    
    let categoriesminus = [
        Category(title: "Car"),
        Category(title: "Clothes"),
        Category(title: "Computers"),
        Category(title: "Freetime"),
        Category(title: "Food & Drinks"),
        Category(title: "Entertainment"),
        Category(title: "Gifts"),
        Category(title: "Groceries"),
        Category(title: "Health"),
        Category(title: "Household"),
        Category(title: "Rent"),
        Category(title: "Restaurants & Cafes"),
        Category(title: "Transport")
    ]
    
    let categoriesplus = [
        Category(title: "Business Income"),
        Category(title: "Salary"),
        Category(title: "Stock Market"),
        Category(title: "Tax Refunds")
    ]
    
    var body: some View {
        List(categories) { category in
            CategoryElementView(category: category, categroytemp: $categroytemp)
            
        }
    }
}

struct CategorySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectView(categroytemp: .constant(""), transactiontypetemp: .constant(false))
            .preferredColorScheme(.dark)
    }
}
