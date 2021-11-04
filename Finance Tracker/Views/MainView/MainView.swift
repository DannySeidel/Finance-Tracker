//
//  MainView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct MainView: View {
    @State private var showtransactionsheet = false
    @State private var showsettingssheet = false
    @EnvironmentObject var data: Data
    
    var body: some View {
        NavigationView {
            ScrollView {
                BalanceView()
                    .frame(height: 150)
                    .padding()
                AnalyticsFrameView()
                    .frame(height: 400)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showsettingssheet.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                    .foregroundColor(.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showtransactionsheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Overview")
        }
        .sheet(isPresented: $showtransactionsheet) {
            AddTransactionView(showTransactionSheet: $showtransactionsheet)
                .environmentObject(Data())
        }
        .sheet(isPresented: $showsettingssheet) {
            SettingsView()
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
