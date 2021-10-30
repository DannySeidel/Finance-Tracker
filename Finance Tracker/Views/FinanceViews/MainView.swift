//
//  MainView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    ScrollView {
                        BalanceView()
                            .foregroundColor(Color(.systemGray6))
                            .frame(height: 150)
                            .padding()
                        AnalyticsOverviewView()
                            .frame(height: 450)
                            .padding()
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                .navigationTitle("Balance")
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
