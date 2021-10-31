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
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    ScrollView {
                        BalanceView()
                            .foregroundColor(Color(.systemGray6))
                            .frame(height: 150)
                            .padding()
                        AnalyticsFrameView()
                            .frame(height: 400)
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showsettingssheet.toggle()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                        }
                        .foregroundColor(Color(.white))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showtransactionsheet.toggle()
                        } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                        }
                        .foregroundColor(Color(.white))
                    }
                }
                .navigationTitle("Overview")
            }
            .sheet(isPresented: $showtransactionsheet) {
                AddTransactionView()
            }
            .sheet(isPresented: $showsettingssheet) {
                SettingsView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
