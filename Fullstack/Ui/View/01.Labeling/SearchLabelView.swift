//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색

import SwiftUI

// MARK: - SearchBarTextField

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

// MARK: - Search Label View Parent View

struct SearchLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing: Bool = false
    @State private var keyword: String = ""
    @State var selectedLabel: String = ""
    @State private var numberOfLabels: Int = labelEntities.count
    @State private var recentKeywords: [Label] = [Label(label: "OOTD", color: "Cobalt_Blue"),
                                                  Label(label: "컬러 팔레트", color: "Yellow"),
                                                  Label(label: "UI 레퍼런스", color: "Red"),
                                                  Label(label: "편집디자인", color: "Violet")]

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                if self.keyword.isEmpty {
                    Text("최근에 검색한 라벨").offset(x: -80)
                        .font(.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(Color.PRIMARY_2)
                    FlexibleView(data: labelEntities.prefix(5), spacing: 8, alignment: HorizontalAlignment.leading) {
                        label in Button(action: {
                            self.keyword = label.label
                        }) {
                            Text(verbatim: label.label)
                                .padding(8)
                                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                                .background(giveLabelBackgroundColor(color: label.color))
                                .foregroundColor(giveTextForegroundColor(color: label.color))
                        }
                    }
                    Spacer(minLength: 20)
                    HStack {
                        Text("내 라벨")
                            .font(.custom("Apple SD Gothic Neo", size: 14))
                            .foregroundColor(Color.PRIMARY_2)
                        Text("\(numberOfLabels)").foregroundColor(Color.KEY_ACTIVE)
                            .font(.custom("Apple SD Gothic Neo", size: 14))

                    }.offset(x: -80)

                    FlexibleView(data: labelEntities, spacing: 8, alignment: HorizontalAlignment.leading) {
                        label in Button(action: {
                            print(label)
                        }) {
                            Text(verbatim: label.label)
                                .padding(8)
                                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                                .background(giveLabelBackgroundColor(color: label.color))
                                .foregroundColor(giveTextForegroundColor(color: label.color))
                        }
                    }
                } else {
                    if labelEntities.filter { $0.label.contains(keyword) }.count > 0 {
                        HStack {
                            Text("검색 결과")
                                .font(.custom("Apple SD Gothic Neo", size: 14))
                                .foregroundColor(Color.PRIMARY_2)
                            Text("\(labelEntities.filter { $0.label.contains(keyword) }.count)").foregroundColor(Color.KEY_ACTIVE)
                                .font(.custom("Apple SD Gothic Neo", size: 14))
                        }.offset(x: -140)

                        FlexibleView(data: labelEntities.filter {
                            keyword.isEmpty ? true : $0.label.contains(keyword)
                        }, spacing: 8, alignment: HorizontalAlignment.leading) {
                            label in Button(action: {
                                print(label)
                            }) {
                                Text(verbatim: label.label)
                                    .padding(8)
                                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                                    .background(giveLabelBackgroundColor(color: label.color))
                                    .foregroundColor(giveTextForegroundColor(color: label.color))
                            }
                        }
                    } else {
                        VStack(alignment: .center) {
                            Spacer(minLength: 143)
                            Image("icon_empty_state_search")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                            Spacer(minLength: 20)
                            Text("검색 결과가 없습니다.")
                                .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                                .foregroundColor(Color.PRIMARY_1)

                            Spacer(minLength: 10)
                            Text("라벨을 생성하여 스크린샷에 라벨을 추가해보세요.")
                                .font(.custom("AppleSDGothicNeo-Bold", size: 18))
                                .foregroundColor(Color.PRIMARY_2)
                            Spacer(minLength: 30)
                            NavigationLink(
                                destination: AddNewLabelView()) {
                                Text("라벨 생성하기")
                                    .foregroundColor(Color.PRIMARY_1)
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .frame(width: 160, height: 48, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                    .background(Color.KEY_ACTIVE)
                                    .cornerRadius(2)
                            }
                        }

                    }
                }
            }.padding(12)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack {
                        HStack {
                            SearchBarTextField(text: $keyword, placeholder: " 라벨을 검색해보세요")
                                .frame(width: 240, height: 20)
                                .padding(10)
                                .padding(.horizontal, 25)
                                .background(Color.DEPTH_4_BG)
                                .cornerRadius(2)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                            .padding(.leading, 5)
                                    }
                                    .padding(5)
                                )
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                        }

                        Button(action: onClickedBackBtn) {
                            Text("취소").foregroundColor(Color.PRIMARY_1)
                                .font(.custom("AppleSDGothicNeo-Medium", size: 16))
                        }
                    }.padding(5)
                )
        }
    }

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }
}
