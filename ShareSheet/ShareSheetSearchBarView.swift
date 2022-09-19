//
//  ShareSheetSearchBarView.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/17.
//

import SwiftUI

struct SearchBarTextField: UIViewRepresentable {
    @Binding var text: String
    @State private var showCancelButton: Bool = false

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

struct ShareSheetSearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("라벨을 검색하거나 추가해 보세요.", text: $text)
                .padding(.leading, 30)
                .frame(height: 40, alignment: .center)
                .background(Color.DEPTH_2)
                .cornerRadius(2)
                .overlay(
                    HStack {
                        Image("Icon_search")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                if self.text != "" {
                                    Image("btn_Icon_cancel")
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    }
                )

                .onTapGesture {
                    self.isEditing = true
                }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}


