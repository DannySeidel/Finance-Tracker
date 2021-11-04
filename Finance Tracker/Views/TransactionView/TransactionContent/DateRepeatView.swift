//
//  DateRepeatView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct DateRepeatView: View {
    @State private var transactionRepeat = 0
    
    var body: some View {
        Picker("Repeat", selection: $transactionRepeat) {
            Text("Never").tag(0)
            Text("Daily").tag(1)
            Text("Weekly").tag(2)
            Text("Monthly").tag(3)
            Text("Yearly").tag(4)
        }
        .pickerStyle(.inline)
    }
}

struct DateRepeatView_Previews: PreviewProvider {
    static var previews: some View {
        DateRepeatView()
    }
}
