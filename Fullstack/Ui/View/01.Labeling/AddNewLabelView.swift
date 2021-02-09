//
//  AddNewLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨추가 화면

import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
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

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "저장완료", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)

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

struct ColorPaletteModalView: View {
    var body: some View {
        VStack {
            Text("라벨 색 선택하기")
                .foregroundColor(.white)
        }
    }
}

struct AddNewLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""

    var body: some View {
        VStack {
            FirstResponderTextField(text: $text, placeholder: "새 라벨 이름 입력")
                .padding(60)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.black)
                            .frame(width: 20, height: 20, alignment: .leading)
                            .padding(.leading, -100)
                    }
                )
        }

        .navigationBarBackButtonHidden(true)
        .navigationTitle("라벨 엘범 추가")
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

struct AddNewLabelView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLabelView()
    }
}
