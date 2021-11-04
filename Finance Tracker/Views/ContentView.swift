//
//  ContentView.swift
//  Finance Tracker
//
//  Colors:
//  Green  Color(red: 35/255, green: 310/255, blue: 139/255)
//  Red  Color(red: 242/255, green: 67/255, blue: 24/255)
//
//  Created by Danny Seidel on 30.10.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .background(Color.black)
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .background(Color.black)
    }
}
