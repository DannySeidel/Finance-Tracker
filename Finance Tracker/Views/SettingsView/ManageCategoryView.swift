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
    @State private var editMode = EditMode.inactive
    
    var categories: [Category] {
        categorytype ? data.categoriesplus : data.categoriesminus
    }
    
    var sortedCategories: [Category] {
        categories.sorted(by: {$0.title<$1.title})
    }
    
    var body: some View {
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
                ForEach(sortedCategories) { category in
                    Text(category.title)
                }
                .onDelete(perform: onDelete)
            }
        }
        .navigationTitle("Edit Categories")
        .navigationBarItems(leading: EditButton(), trailing: addButton)
        .environment(\.editMode, $editMode)
    }
    
    var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }

    private func onDelete(offsets: IndexSet) {
        categorytype ? data.categoriesplus.remove(atOffsets: offsets) : data.categoriesminus.remove(atOffsets: offsets)
    }

    private func onAdd() {
        categorytype ? data.categoriesplus.append(Category(title: "nameless")) : data.categoriesminus.append(Category(title: "nameless"))
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
