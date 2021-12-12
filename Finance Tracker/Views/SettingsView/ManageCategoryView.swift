//
//  ManageCategoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 11.11.21.
//

import SwiftUI


struct ManageCategoryView: View {
    @EnvironmentObject var data: Data
    @State private var categoryType = false
    @State private var addCategoryAlert = false
    @State private var searchText = ""
    
    var searchCategories: [String] {
        if searchText.isEmpty {
            return categoryType ? data.categoriesplus.sorted(by: {$0<$1}) : data.categoriesminus.sorted(by: {$0<$1})
        } else {
            return categoryType ?
            data.categoriesplus.filter { $0.contains(searchText) }.sorted(by: {$0<$1}) :
                data.categoriesminus.filter { $0.contains(searchText) }.sorted(by: {$0<$1})
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
                            Text(category)
                        }
                        .onDelete(perform: onDelete)
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
                Button("Add Category") {
                    addCategoryAlert.toggle()
                }
            }
            .navigationTitle("Edit Categories")
            .opacity(opacity)
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        let categoryName = searchCategories[offsets.first!]
        
        if categoryType {
            data.categoriesplus.remove(at: data.categoriesplus.firstIndex(of: categoryName)!)
        } else {
            data.categoriesminus.remove(at: data.categoriesminus.firstIndex(of: categoryName)!)
        }
    }
}

struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageCategoryView()
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
