//
//  SettingsView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var data: Data
    @AppStorage("storeNewCategoriesByDefault") var storeNewCategoriesByDefault: Bool = true
    @AppStorage("DefaultTimespan") var defaultTimespan: Int = 0
    
    @Binding var showSettingsSheet: Bool
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Save new Categories", isOn: $storeNewCategoriesByDefault)
                NavigationLink(destination: EditCategoryView()) {
                    Text("Edit saved Categories")
                }
                Picker("Default Timespan", selection: $defaultTimespan) {
                    Text("Current Month").tag(0)
                    Text("Previous 30 Days").tag(1)
                    Text("Last Month").tag(2)
                    Text("Last 3 Months").tag(3)
                    Text("Last 6 Months").tag(4)
                    Text("Current Year").tag(5)
                    Text("Last Year").tag(6)
                    Text("Previous 365 Days").tag(7)
                }
                NavigationLink(destination: ManageAnalyticsView()) {
                    Text("Standart Diagram Type")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing:
                    Button("Done") {
                        data.refreshBalance()
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
