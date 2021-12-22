//
//  MapView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 01.11.21.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color.init(UIColor(named: "AppElement")!))
            Text("MapView")
        }
        .padding()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewLayout(.fixed(width: 400, height: 200))
            .background(Color.init(UIColor(named: "AppBackground")!))
        MapView()
            .previewLayout(.fixed(width: 400, height: 200))
            .preferredColorScheme(.dark)
    }
}
