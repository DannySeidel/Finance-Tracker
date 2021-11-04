//
//  TransactionDateView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct DateView: View {
    @Binding var dateandtime: Date
    @Binding var repeattag: Int
    @Binding var endrepeat: Bool
    @Binding var repeatenddate: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(.systemGray5))
            VStack {
                HStack {
                    Text("Date")
                    DatePicker(selection: $dateandtime, in: ...Date()) {
                        
                    }
                    .datePickerStyle(CompactDatePickerStyle())
                }
                
                Divider()
                
                HStack {
                    Text("Repeat")
                    
                    Spacer()
                    
                    Picker("Repeat", selection: $repeattag) {
                        Image(systemName: "nosign").tag(0)
                        Image(systemName: "d.square.fill").tag(1)
                        Image(systemName: "w.square.fill").tag(2)
                        Image(systemName: "m.square.fill").tag(3)
                        Image(systemName: "y.square.fill").tag(4)
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading)
                }
                
                if repeattag != 0 {
                    Divider()
                    
                    HStack {
                        Text("End Repeat")
                                                
                        if endrepeat == true {
                            DatePicker("", selection: $repeatenddate, in: Date()..., displayedComponents: .date)
                                .padding(-2)
                        }
                        Toggle("", isOn: $endrepeat)
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
            dateandtime: .constant(Date.now), repeattag: .constant(0), endrepeat: .constant(false), repeatenddate: .constant(Date.now)
        )
            .preferredColorScheme(.dark)
    }
}
