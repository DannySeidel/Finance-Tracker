//
//  SettingsView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("storeNewCategoriesByDefault") var storeNewCategoriesByDefault: Bool = true
    
    @Binding var showSettingsSheet: Bool
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Save new Categories", isOn: $storeNewCategoriesByDefault)
                NavigationLink(destination: EditCategoryView()) {
                    Text("Edit saved Categories")
                }
                NavigationLink(destination: ManageAnalyticsView()) {
                    Text("Standart Diagram Type")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing:
                    Button("Done") {
                        showSettingsSheet.toggle()
                    }
                    .foregroundColor(.white)
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsSheet: .constant(true))
            .preferredColorScheme(.dark)
    }
}
