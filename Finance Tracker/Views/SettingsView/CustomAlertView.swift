//
//  CustonAlert.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 22.11.21.
//

import SwiftUI

struct CustomAlertView<Content:View>: View {
    @EnvironmentObject var data : Data
    @State private var alertText = ""
    @Binding var addCategoryAlert : Bool
    @Binding var categories: [Category]
    
    @ViewBuilder var content : () -> Content
    
    var body: some View {
        ZStack {
            content()
            if addCategoryAlert {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.black)
                        .opacity(0.90)
                    VStack {
                        Text("Enter Category Name")
                        TextField("", text: $alertText)
                            .background(Color(.systemGray5).cornerRadius(5))

                        Spacer()
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                addCategoryAlert.toggle()
                                alertText = ""
                            }
                            .frame(width: 60)
                            
                            Spacer()
                            
                            Divider()
                            
                            Spacer()
                            Button("Add"){
                                addCategoryAlert.toggle()
                                onAdd()
                                alertText = ""
                            }
                            .frame(width: 61)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                }
                .padding(25)
                .frame(height: 150)
                .offset(y: -30)
            }
        }
    }
    
    private func onAdd() {
        categories.append(Category(title: alertText))
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(addCategoryAlert: .constant(true), categories: .constant([]), content: {})
            .preferredColorScheme(.dark)
        
    }
}
