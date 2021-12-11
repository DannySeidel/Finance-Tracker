//
//  SettingsView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsSheet: Bool
    @EnvironmentObject var data: Data
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ManageCategoryView().environmentObject(data)) {
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
