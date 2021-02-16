//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색

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

struct BadgeView: View {
    var label: Label
    @Binding var selectedLabel: String
    @Binding var letters: Int
    var body: some View {
        Button(action: {
            self.selectedLabel = self.label.label
            letters = self.label.label.count
        }) {
            Text(label.label).foregroundColor(giveTextForegroundColor(color: label.color))
        }
        .lineSpacing(5)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .cornerRadius(2)
        .background(giveLabelBackgroundColor(color: label.color))
    }
}

struct SearchLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var letters: Int = 0
    @State private var isEditing = false
    @State private var keyword: String = ""
    @State var selectedLabel: String = ""
    @State private var numberOfLabels: Int = labelEntities.count

    var rows: [GridItem] {
        [GridItem(.adaptive(minimum: CGFloat(letters * 100), maximum: 100))]
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("최근에 검색한 라벨")

            HStack {
                Text("선택할 수 있는 라벨")
                Text("\(numberOfLabels)").foregroundColor(Color(red: 37/255, green: 124/255, blue: 204/255))
            }
            
            ScrollView {
                FlexibleView(data: labelEntities, spacing: 8, alignment: HorizontalAlignment.leading) {
                    label in Text(verbatim: label.label)
                        .padding(8)
                        .background(giveLabelBackgroundColor(color: label.color))
                        .foregroundColor(giveTextForegroundColor(color: label.color))
                }
                
            }

//            LazyHGrid(rows: rows, content: {
//                ForEach(labelEntities, id: \.self) {
//                    label in
//                    BadgeView(label: label, selectedLabel: $selectedLabel, letters: $letters)
//                }
//            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            HStack {
                HStack {
                    SearchBarTextField(text: $keyword, placeholder: " 라벨을 검색해보세요")
                        .frame(width: 240, height: 20)
                        .padding(10)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(2)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                    .padding(.leading, 10)
                            }
                            .padding(.horizontal, 10)
                        )
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.isEditing = true
                        }
                }

                Button(action: onClickedBackBtn) {
                    Text("취소").foregroundColor(Color.white)
                }
            }.padding(5)
        )
    }

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SearchLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLabelView()
    }
}
