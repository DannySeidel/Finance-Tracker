//
//  AddTransactionView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 31.10.21.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var showTransactionSheet: Bool
    @State private var transactionType = 0
    @EnvironmentObject var data: Data
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        AmountView()
                        InfoView()
                        DateView()
                        MapView()
                    }
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel") {
                                emptydata()
                                showTransactionSheet.toggle()
                            }
                            VStack {
                                Picker("", selection: $transactionType) {
                                    Image(systemName: "minus").tag(0)
                                    Image(systemName: "plus").tag(1)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                                
                            }
                            .padding(.leading, (geometry.size.width / 2.0) - 160)
                        },
                    trailing:
                        Button("Add") {
                            adddata()
                            showTransactionSheet.toggle()
                        }
                )
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.white))
            }
        }
        .preferredColorScheme(.dark)
    }
    private func adddata() {
        AmountView().saveamount()
        InfoView().saveinfo()
    }
    private func emptydata() {
        AmountView().emptyamount()
        InfoView().emptyinfo()
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(showTransactionSheet: .constant(false))
            .environmentObject(Data())
    }
}
