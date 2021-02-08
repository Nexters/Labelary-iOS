//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색

import SwiftUI

struct SearchBarTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = true

        init(text: Binding<String>) {
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()

        textField.delegate = context.coordinator
        textField.placeholder = placeholder

        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}

struct SearchLabelView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var isEditing = false
    @Binding var keyword: String
    var body: some View {
        HStack {
            SearchBarTextField(text: $keyword, placeholder: "  라벨 검색")
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            .padding(.leading, 8)
                    }
                    .padding(.horizontal, 10)
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            Button(action: onClickedBackBtn) {
                Image(systemName: "arrow.left")
            }
        )
    }

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SearchLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLabelView(keyword: .constant(""))
    }
}
