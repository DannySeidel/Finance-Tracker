//
//  ManageCategoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 11.11.21.
//

import SwiftUI


struct ManageCategoryView: View {
    @EnvironmentObject var data: Data
    @State private var categorytype = false
    @State private var addCategoryAlert = false
    @State private var searchText = ""
    
//    .sorted(by: {$0<$1})
    
    var searchCategories: [String] {
        if searchText.isEmpty {
            return categorytype ? data.categoriesplus.sorted(by: {$0<$1}) : data.categoriesminus.sorted(by: {$0<$1})
        } else {
            return categorytype ?
            data.categoriesplus.filter { $0.contains(searchText) }.sorted(by: {$0<$1}) :
                data.categoriesminus.filter { $0.contains(searchText) }.sorted(by: {$0<$1})
        }
    }
    
    var opacity: Double {
        addCategoryAlert ? 0.6 : 1
    }
    
    var body: some View {
        
        CustomAlertView(addCategoryAlert: $addCategoryAlert, categories: categorytype ? $data.categoriesplus : $data.categoriesminus) {
            
            VStack {
                VStack {
                    Picker("", selection: $categorytype) {
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
                    .searchable(text: $searchText)
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
        let categoryname = searchCategories[offsets.first!]
        
        if categorytype {
            data.categoriesplus.remove(at: data.categoriesplus.firstIndex(of: categoryname)!)
        } else {
            data.categoriesminus.remove(at: data.categoriesminus.firstIndex(of: categoryname)!)
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
