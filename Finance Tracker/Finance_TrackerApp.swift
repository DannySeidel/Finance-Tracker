//
//  Finance_TrackerApp.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

@main
struct Finance_TrackerApp: App {
    @StateObject var data = Data()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(data)
        }
    }
}
