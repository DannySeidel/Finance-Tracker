//
//  TransactionDateView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct DateView: View {
    @Binding var dateAndTime: Date
    @Binding var repeatTag: Int
    @Binding var endRepeat: Bool
    @Binding var repeatEndDate: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            VStack {
                HStack {
                    Text("Date")
                    DatePicker(selection: $dateAndTime, in: ...Date()) {
                        
                    }
                    .datePickerStyle(CompactDatePickerStyle())
                }
                
                Divider()
                
                HStack {
                    Text("Repeat")
                    
                    Spacer()
                    
                    Picker("Repeat", selection: $repeatTag) {
                        Image(systemName: "nosign").tag(0)
                        Image(systemName: "d.square.fill").tag(1)
                        Image(systemName: "w.square.fill").tag(2)
                        Image(systemName: "m.square.fill").tag(3)
                        Image(systemName: "y.square.fill").tag(4)
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading)
                }
                
                if repeatTag != 0 {
                    Divider()
                    
                    HStack {
                        Text("End Repeat")
                                                
                        if endRepeat == true {
                            DatePicker("", selection: $repeatEndDate, in: Date()..., displayedComponents: .date)
                                .padding(-2)
                        }
                        Toggle("", isOn: $endRepeat)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

struct TransactionDateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(
            dateAndTime: .constant(Date.now), repeatTag: .constant(0), endRepeat: .constant(false), repeatEndDate: .constant(Date.now)
        )
            .preferredColorScheme(.dark)
    }
}
