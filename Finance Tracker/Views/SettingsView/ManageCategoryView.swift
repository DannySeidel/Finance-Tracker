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
    
    var categories: [Category] {
        categorytype ? data.categoriesplus : data.categoriesminus
    }
    
//    .sorted(by: {$0.title<$1.title})
    
    var opacity: Double {
        addCategoryAlert ? 0.6 : 1
    }
    
    var body: some View {
        
        CustomAlertView(addCategoryAlert: $addCategoryAlert, categories: categorytype ? $data.categoriesplus : $data.categoriesminus) {
            
            VStack {
                VStack(spacing: -10) {
                    Picker("", selection: $categorytype) {
                        Label("Expense", systemImage: "minus")
                            .tag(false)
                        Label("Income", systemImage: "plus")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    List {
                        ForEach(categories) { category in
                            Text(category.title)
                        }
                        .onDelete(perform: onDelete)
                    }
                    
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
        categorytype ? data.categoriesplus.remove(atOffsets: offsets) : data.categoriesminus.remove(atOffsets: offsets)
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
