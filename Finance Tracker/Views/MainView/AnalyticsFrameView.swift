//
//  AnalyticsOverviewView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct AnalyticsFrameView: View {
    var body: some View {
            NavigationLink(destination: AnalyticsView()) {
                ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.init(UIColor(named: "AppElement")!))
                
                VStack {
                    Spacer()
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Button("Show analytics") {
                        }
                        .foregroundColor(Color.init(UIColor(named: "AppText")!))
                        
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

struct AnalyticsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsFrameView()
            .previewLayout(.fixed(width: 400, height: 400))
            .background(Color.init(UIColor(named: "AppBackground")!))
        AnalyticsFrameView()
            .previewLayout(.fixed(width: 400, height: 400))
            .preferredColorScheme(.dark)
    }
}
