//
//  ManageCategoryView.swift
//  Finance Tracker
//
//  Created by Danny Seidel on 11.11.21.
//

import SwiftUI
import UIKit
import Combine


struct ManageCategoryView: View {
    @EnvironmentObject var data: Data
    @State private var categoryType = false
    @State private var searchText = ""
    @State var alertIsPresented = false
    @State var categoryName: String? = nil
    
    var searchCategories: [String] {
        if searchText.isEmpty {
            return categoryType ? data.categoriesplus.sorted(by: {$0<$1}) : data.categoriesminus.sorted(by: {$0<$1})
        } else {
            return categoryType ?
            data.categoriesplus.filter { $0.contains(searchText) }.sorted(by: {$0<$1}) :
            data.categoriesminus.filter { $0.contains(searchText) }.sorted(by: {$0<$1})
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Picker("", selection: $categoryType) {
                    Label("Expense", systemImage: "minus")
                        .tag(false)
                    Label("Income", systemImage: "plus")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.leading)
                .padding(.trailing)
                
                List {
                    ForEach(searchCategories, id: \.self) { category in
                        Text(category)
                    }
                    .onDelete(perform: onDelete)
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            Button("Add Category") {
                alertIsPresented.toggle()
            }
        }
        .textFieldAlert(isPresented: $alertIsPresented) { () -> TextFieldAlert in
            TextFieldAlert(title: "Enter Category Name", message: nil, text: self.$categoryName)
        }
        .navigationTitle("Edit Categories")
    }
    
    private func onDelete(offsets: IndexSet) {
        let categoryName = searchCategories[offsets.first!]
        
        if categoryType {
            data.categoriesplus.remove(at: data.categoriesplus.firstIndex(of: categoryName)!)
        } else {
            data.categoriesminus.remove(at: data.categoriesminus.firstIndex(of: categoryName)!)
        }
    }
}



class TextFieldAlertViewController: UIViewController {
    init(title: String, message: String?, text: Binding<String?>, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.message = message
        self._text = text
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let alertTitle: String
    private let message: String?
    @Binding private var text: String?
    private var isPresented: Binding<Bool>?
    
    private var subscription: AnyCancellable?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }
    
    private func presentAlertController() {
        guard subscription == nil else { return }
        
        let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            self.subscription = NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: textField)
                .map { ($0.object as? UITextField)?.text }
                .assign(to: \.text, on: self)
        }
        
        let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.isPresented?.wrappedValue = false
//            retrun func
        }
        vc.addAction(action)
        present(vc, animated: true, completion: nil)
    }
}


struct TextFieldAlert {
    let title: String
    let message: String?
    @Binding var text: String?
    var isPresented: Binding<Bool>? = nil
    
    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, message: message, text: $text, isPresented: isPresented)
    }
}


extension TextFieldAlert: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = TextFieldAlertViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, message: message, text: $text, isPresented: isPresented)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: UIViewControllerRepresentableContext<TextFieldAlert>) {
    }
}


struct TextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert
    
    var body: some View {
        ZStack {
            if (isPresented) { content().dismissable($isPresented) }
            presentingView
        }
    }
}


extension View {
    func textFieldAlert(isPresented: Binding<Bool>,
                        content: @escaping () -> TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented,
                         presentingView: self,
                         content: content)
    }
}


struct ManageCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageCategoryView()
                .environmentObject(Data())
                .preferredColorScheme(.dark)
        }
    }
}
