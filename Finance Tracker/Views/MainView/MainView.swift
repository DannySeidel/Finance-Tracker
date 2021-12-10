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
    
    var body: some View {
        NavigationView {
            ScrollView {
                BalanceView()
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
            .navigationTitle("Overview")
        }
        .sheet(isPresented: $showTransactionSheet) {
            AddTransactionView(showTransactionSheet: $showTransactionSheet)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(showSettingsSheet: $showSettingsSheet)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Data())
    }
}
