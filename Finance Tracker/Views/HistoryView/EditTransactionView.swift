//
//  EditTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 15.12.21.
//

import SwiftUI

struct EditTransactionView: View {
    @EnvironmentObject var data: Data
    
    @State private var amountTemp: Double?
    @State private var nameTemp: String?
    @State private var categoryTemp: String?
    @State private var dateAndTimeTemp = Date()
    @State private var repeatTagTemp = 0
    @State private var endRepeatTemp = false
    @State private var repeatEndDateTemp = Date()
    
    @Binding var showingSheet: Bool
    
    @State var transactionTypeTemp: Bool
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        MapView()
                    }
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                showingSheet.toggle()
                            }
                            VStack {
                                Picker("", selection: $transactionTypeTemp) {
                                    Image(systemName: "minus").tag(false)
                                    Image(systemName: "plus").tag(true)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                                
                            }
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Save") {
                            showingSheet.toggle()
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
        }
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditTransactionView(showingSheet: .constant(true), transactionTypeTemp: false)
    }
}
