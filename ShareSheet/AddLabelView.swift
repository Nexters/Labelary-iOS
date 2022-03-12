//
//  AddLabelView.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/03/09.
//

import SwiftUI
import UIKit

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = true

        init(text: Binding<String>) {
            self._text = text
        }

        func testFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        let customFont = UIFont(name: (textField.font?.fontName)!, size: 28.0)!

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "입력완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(textField.doneButtonTapped(button:)))

        toolBar.items = [flexibleSpace, doneButton]
        toolBar.setItems([doneButton], animated: true)
        textField.font = customFont
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.inputAccessoryView = toolBar

        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}

extension UITextField {
    @objc func doneButtonTapped(button: UIBarButtonItem) {
        resignFirstResponder()
    }
}

struct AddLabelView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    @State var text: String = ""
    @State var selectedIndex: Int? = -1
    @State var isSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("라벨명").font(.custom("Apple SD Gothic Neo", size: 12))
                .frame(width: 37, height: 20, alignment: .leading)
                .padding(7)

            FirstResponderTextField(text: $text, placeholder: "라벨명을 입력해주세요.")
                .frame(width: 350, height: 40, alignment: .trailing)
                .foregroundColor(.white)
                .padding(7)

            Text("라벨 컬러 선택").font(.custom("Apple SD Gothic Neo", size: 12))
                .frame(width: 81, height: 20, alignment: .leading)
                .padding(7)

            HStack(alignment: .center) {
                VStack {
                    // ForEach 부하걸리니까 수정해야함
                    ForEach(0 ..< labelButtons.count / 2) {
                        button in

                        Button(action: {
                            self.selectedIndex = button
                            self.isSelected = true

                        }) {
                            if selectedIndex == button {
                                Image("Label_middle_Selected_\(self.labelButtons[button])")

                            } else {
                                Image("Label_middle_dark_\(self.labelButtons[button])")
                            }
                        }
                        .padding([.top, .leading], 10)
                    }
                }

                VStack {
                    ForEach(5 ..< labelButtons.count) {
                        button in

                        Button(action: {
                            self.selectedIndex = button
                            print(button)
                            self.isSelected = true
                        }) {
                            if selectedIndex == button {
                                Image("Label_middle_Selected_\(self.labelButtons[button])")

                            } else {
                                Image("Label_middle_dark_\(self.labelButtons[button])")
                            }
                        }
                        .padding([.top, .leading], 10)
                    }
                }
            }
            Spacer()
        }
    }
}
