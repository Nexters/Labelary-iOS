//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색 SearchLabelView.swift

import SwiftUI

// MARK: - SearchBarTextField

struct SearchBarTextField: UIViewRepresentable {
    @Binding var text: String

    let placeholder: String

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = true

        init(text: Binding<String>) {
            _text = text
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
    @ObservedObject var model = ShowAddNewLabelView()
    @State private var isEditing: Bool = false
    @State private var keyword: String = ""
    @State var selectedLabel: String = ""
    @ObservedObject var output = Output()
    @State private var recentKeywords: [LabelEntity] = []

    let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    // get all labels
    let searchLabel = SearchLabel(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    // 키워드로 라벨 검색
    let loadSearchLabelData = LoadSearchLabelData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    // 최근 검색한 라벨 데이타 불러오기

    init() {
        let cancelBag = CancelBag()
        loadLabelingSelectData.get()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [self] data in
                      output.labels = data
                  }).store(in: cancelBag)

        loadSearchLabelData.get()
            .sink(receiveCompletion: { _ in }, receiveValue: {
                [self] data in
                output.recentlySearchedLabels = data.recentlySearchedLabels
            }).store(in: cancelBag)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.DEPTH_5.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                if self.keyword.isEmpty {
                    Text("최근에 검색한 라벨".localized())
                        .font(Font.B2_MEDIUM)
                        .foregroundColor(Color.PRIMARY_2)
                    FlexibleView(data: output.labels.prefix(5), spacing: 8, alignment: HorizontalAlignment.leading) {
                        label in Button(action: {
                            self.keyword = label.name
                        }) {
                            Text(verbatim: label.name)
                                .padding(8)
                                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                                .background(giveLabelBackgroundColor(color: label.color))
                                .foregroundColor(giveTextForegroundColor(color: label.color))
                        }
                    }
                    HStack {
                        Text("내 라벨".localized())
                            .font(Font.B2_MEDIUM)
                            .foregroundColor(Color.PRIMARY_2)
                        Text("\(self.output.labels.count)").foregroundColor(Color.KEY_ACTIVE)
                            .font(.custom("Apple SD Gothic Neo", size: 14))
                    }.padding(.top, 40)

                    FlexibleView(data: output.labels, spacing: 8, alignment: HorizontalAlignment.leading) {
                        label in Button(action: {}) {
                            Text(verbatim: label.name)
                                .padding(8)
                                .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                                .background(giveLabelBackgroundColor(color: label.color))
                                .foregroundColor(giveTextForegroundColor(color: label.color))
                        }
                    }
                } else {
                    if output.labels.filter { $0.name.contains(keyword) }.count > 0 {
                        HStack {
                            Text("검색 결과".localized())
                                .font(.custom("Apple SD Gothic Neo", size: 14))
                                .foregroundColor(Color.PRIMARY_2)
                            Text("\(output.labels.filter { $0.name.contains(keyword) }.count)").foregroundColor(Color.KEY_ACTIVE)
                                .font(.custom("Apple SD Gothic Neo", size: 14))
                        }.offset(x: -140)

                        FlexibleView(data: output.labels.filter {
                            keyword.isEmpty ? true : $0.name.contains(keyword)
                        }, spacing: 8, alignment: HorizontalAlignment.leading) {
                            label in Button(action: {
                                print(label)
                            }) {
                                Text(verbatim: label.name)
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

                            Text("검색 결과가 없습니다.".localized())
                                .font(Font.H3_BOLD)
                                .foregroundColor(Color.PRIMARY_1)
                                .padding(.top, 20)

                            Text("라벨을 생성하여 스크린샷에".localized())
                                .font(Font.B1_REGULAR)
                                .foregroundColor(Color.PRIMARY_2)
                                .padding(.top, 20)
                            Text("라벨을 추가해보세요.".localized())
                                .font(Font.B1_REGULAR)
                                .foregroundColor(Color.PRIMARY_2)

                            Spacer(minLength: 30)

                            NavigationLink(
                                destination: AddNewLabelView()) {
                                Text("라벨 생성하기".localized())
                                        .foregroundColor(Color.PRIMARY_1)
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                        .frame(width: 160, height: 48, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                        .background(Color.KEY_ACTIVE)
                                        .cornerRadius(2)
                            }.isDetailLink(false)

                            Spacer()
                        }
                    }
                }

            }.padding(12)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack {
                        SearchBarTextField(text: $keyword, placeholder: " 라벨을 검색해보세요".localized())
                            .frame(width: 240, height: 20)
                            .padding(10)
                            .padding(.horizontal, 25)
                            .background(Color.DEPTH_4_BG)
                            .cornerRadius(2)
                            .overlay(
                                HStack {
                                    Image("Icon_search")
                                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                        .padding(.leading, 5)
                                    Spacer()
                                    Image("btn_icon_cancel")
                                        .opacity(keyword == "" ? 0 : 1)
                                        .onTapGesture {
                                            self.keyword = "" // 화면에서 갱신이 안되는 에러가 있다.
                                        }
                                }
                                .padding(5)
                            )
                            .padding(.horizontal, 10)

                        Button(action: onClickedBackBtn) {
                            Text("취소").foregroundColor(Color.PRIMARY_1)
                                .font(.custom("AppleSDGothicNeo-Medium", size: 16))
                        }
                    }.padding(5)
                )
        }.onAppear(perform: {
//            posthog?.capture("[01.Labeling]SearchLabelView")
        })
    }

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }

    class Output: ObservableObject {
        @Published var labels: [LabelEntity] = [] // get all labels

        @Published var selectedLabels: [LabelEntity] = [] // 선택한 라벨
        @Published var recentlySearchedLabels: [LabelEntity] = [] // 최근에 검색한 라벨
    }
}
