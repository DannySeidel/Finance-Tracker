//
//  AddTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var showTransactionSheet: Bool
    
    @EnvironmentObject var data: Data
    @State private var amounttemp: Double?
    @State private var nametemp: String?
    @State private var categorytemp: String?
    @State private var dateandtimetemp = Date()
    @State private var repeattagtemp = 0
    @State private var endrepeattemp = false
    @State private var repeatenddatetemp = Date()
    
    @State private var transactiontypetemp = false
    
    var factor: Double {
        transactiontypetemp ? 1 : -1
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        AmountView(amounttemp: $amounttemp)
                        
                        InfoView(nametemp: $nametemp, categroytemp: $categorytemp)
                        
                        DateView(dateandtime: $dateandtimetemp, repeattag: $repeattagtemp, endrepeat: $endrepeattemp, repeatenddate: $repeatenddatetemp)
                        
                        MapView()
                    }
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                showTransactionSheet.toggle()
                            }
                            VStack {
                                Picker("", selection: $transactiontypetemp) {
                                    Image(systemName: "minus").tag(false)
                                    Image(systemName: "plus").tag(true)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                                
                            }
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Add") {
                            showTransactionSheet.toggle()
                            amounttemp! *= factor
                            savedata()
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
        }
        .preferredColorScheme(.dark)
    }
    func savedata() {
        if let amounttemp = amounttemp, let nametemp = nametemp, let categorytemp = categorytemp {
            data.transactions.append(
                DataStructure(
                    amount: amounttemp,
                    name: nametemp,
                    category: categorytemp,
                    dateandtime: dateandtimetemp,
                    repeattag: repeattagtemp,
                    endrepeat: endrepeattemp,
                    repeatenddate: repeatenddatetemp
                )
            )
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
    }
}
