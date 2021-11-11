//
//  AnalyticsOverviewView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct AnalyticsFrameView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(.systemGray6))
            
            VStack {
                Spacer()
                
                Divider()
                
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                    Button("Show analytics") {
                        
                    }
                    .foregroundColor(Color(.white))

                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct AnalyticsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsFrameView()
            .frame(height: 400)
            .preferredColorScheme(.dark)
    }
}
