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
            return data.database.getCategories(type: categoryType)
        } else {
            return data.database.getCategories(type: categoryType).filter { $0.name.contains(searchText) }
        }
    }
    
    var opacity: Double {
        addCategoryAlert ? 0.6 : 1
    }
    
    var body: some View {
        CustomAlertView(categoryType: $categoryType, addCategoryAlert: $addCategoryAlert, categories: categoryType ? $data.categoriesIncome : $data.categoriesExpense) {
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
                .background(Color.init(UIColor(named: "AppSheetBackground")!))
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
        
        data.database.deleteCategory(type: categoryType, name: category.name)
    }
}

struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditCategoryView()
                .environmentObject(Data())
            EditCategoryView()
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
