//
//  CustonAlert.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 22.11.21.
//

import SwiftUI

struct CustomAlertView<Content:View>: View {
    @State private var alertText = ""
    @Binding var addCategoryAlert : Bool
    @Binding var categories : [Category]
    
    @ViewBuilder var content : () -> Content
    
    var body: some View {
        ZStack {
            content()
            if addCategoryAlert {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(Color(.systemGray6))
                    VStack {
                        Text("Enter Category Name")
                        TextField("", text: $alertText)
                            .background(Color(.systemGray3).cornerRadius(5))
                        Divider()
                        HStack {
                            Button("Cancel") {
                                addCategoryAlert.toggle()
                                alertText = ""
                            }
                            Button("Add"){
                                addCategoryAlert.toggle()
                                onAdd()
                                alertText = ""
                            }
                        }
                    }
                    .padding()
                }
                .padding()
                .frame(height: 150)
            }
        }
    }
    
    private func onAdd() {
        categories.append(Category(title: alertText))
    }
}

struct CustonAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(addCategoryAlert: .constant(true), categories: .constant([]), content: {})
            .preferredColorScheme(.dark)
        
    }
}
