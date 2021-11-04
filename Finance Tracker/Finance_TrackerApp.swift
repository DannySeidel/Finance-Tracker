//
//  Finance_TrackerApp.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

@main
struct Finance_TrackerApp: App {
    @EnvironmentObject var data: Data
    var body: some Scene {
        WindowGroup {
            MainView()
                .background(Color.black)
        }
    }
}
