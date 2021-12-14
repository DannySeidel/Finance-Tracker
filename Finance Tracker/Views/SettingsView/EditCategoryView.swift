//
//  ManageCategoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 11.11.21.
//

import SwiftUI


struct EditCategoryView: View {
    @EnvironmentObject var data: Data
    @State private var categoryType = false
    @State private var addCategoryAlert = false
    @State private var searchText = ""
    
    var searchCategories: [Category] {
        if searchText.isEmpty {
            return categoryType ? data.database.getPlusCategories() : data.database.getMinusCategories()
        } else {
            return categoryType ?
            data.database.getPlusCategories().filter { $0.name.contains(searchText) } :
            data.database.getMinusCategories().filter { $0.name.contains(searchText) }
        }
    }
    
    var opacity: Double {
        addCategoryAlert ? 0.6 : 1
    }
    
    var body: some View {
        CustomAlertView(categoryType: $categoryType, addCategoryAlert: $addCategoryAlert, categories: categoryType ? $data.categoriesplus : $data.categoriesminus) {
            VStack {
                VStack {
                    Picker("", selection: $categoryType) {
                        Label("Expense", systemImage: "minus")
                            .tag(false)
                        Label("Income", systemImage: "plus")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading)
                    .padding(.trailing)
                    
                    List {
                        ForEach(searchCategories, id: \.self) { category in
                            Text(category.name)
                        }
                        .onDelete(perform: onDelete)
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
                Button("Add Category") {
                    addCategoryAlert.toggle()
                }
            }
            .navigationTitle("Edit saved Categories")
            .opacity(opacity)
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        let category = searchCategories[offsets.first!]
        
        if categoryType {
            data.database.deletePlusCategory(name: category.name)
        } else {
            data.database.deleteMinusCategory(name: category.name)
        }
    }
}

struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditCategoryView()
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
