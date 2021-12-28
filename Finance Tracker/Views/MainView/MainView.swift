//
//  MainView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct MainView: View {
    @State private var showTransactionSheet = false
    @State private var showSettingsSheet = false
    @EnvironmentObject var data: Data
    
    @AppStorage("defaultTimespan") var defaultTimespan: Int = 0
    
    var navigationTitle: String {
        switch defaultTimespan {
        case 1:
            return "Previous 30 days"
        case 2:
            return "Last Month"
        case 3:
            return "Last 3 Months"
        case 4:
            return "Last 6 Months"
        case 5:
            return "Current Year"
        case 6:
            return "Last Year"
        case 7:
            return "Previous 365 Days"
        case 8:
            return "Dev"
        default:
            return "Current Month"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                BalanceView()
                    .frame(height: 140)
                    .padding()
                AnalyticsFrameView()
                    .frame(height: 400)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                    .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showTransactionSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle(navigationTitle)
            .background(
                Color.init(UIColor(named: "AppBackground")!).ignoresSafeArea()
            )
        }
        .sheet(isPresented: $showTransactionSheet) {
            AddTransactionView(showTransactionSheet: $showTransactionSheet)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(showSettingsSheet: $showSettingsSheet)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Data())
        MainView()
            .environmentObject(Data())
            .preferredColorScheme(.dark)
    }
}
