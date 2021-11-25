//
//  SettingsView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showsettingssheet: Bool
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ManageCategoryView()) {
                    Text("Manage Categories")
                }
                NavigationLink(destination: ManageAnalyticsView()) {
                    Text("Standart Diagram Type")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing:
                    Button("Done") {
                        showsettingssheet.toggle()
                    }
                    .foregroundColor(.white)
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showsettingssheet: .constant(true))
            .preferredColorScheme(.dark)
    }
}
