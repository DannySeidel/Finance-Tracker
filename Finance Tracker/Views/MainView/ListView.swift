//
//  ListView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(.systemGray6))
            VStack {
                Button("TestButton1") {
                    
                }
                Divider()
                
                Button("TestButton2") {
                    
                }
                Divider()
                
                Button("TestButton3") {
                    
                }
                Divider()
                
                Button("TestButton4") {
                    
                }
                Divider()
                
                Button("TestButton5") {
                    
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
