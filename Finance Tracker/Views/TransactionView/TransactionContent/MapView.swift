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
                .foregroundColor(Color(.systemGray5))
            Text("MapView")
        }
        .padding()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
