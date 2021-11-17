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
                ForEach(categories) { category in
                    Text(category.title)
                }
//                .onMove(perform: onDelete)
//                .onDelete(perform: onMove)
            }
        }
        .navigationTitle("Edit Categories")
//        .navigationBarItems(leading: EditButton(), trailing: addButton)
//        .environment(\.editMode, $editMode)
    }
//
//    var addButton: some View {
//        switch editMode {
//        case .inactive:
//            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
//        default:
//            return AnyView(EmptyView())
//        }
//    }
//
//    private func onDelete(offsets: IndexSet) {
//        data.categoriesminus.remove(atOffsets: offsets)
//    }
//
//    private func onMove(source: IndexSet, destination: Int) {
//        data.categoriesminus.move(fromOffsets: source, toOffset: destination)
//    }
//
//    private func onAdd() {
//        data.categoriesminus.append(Category(title: "nameless"))
//    }
}

struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ManageCategoryView()
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
