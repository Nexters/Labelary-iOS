//
//  ScreenShotDetailLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/22.
//

import SwiftUI
// 스크린샷 라벨 추가
struct ScreenShotDetailLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewmodel = ViewModel()
    @State var showAddLabelView: Bool = false

    var body: some View {
        ZStack {
            Color.DEPTH_3.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                SearchBar(keyword: self.$viewmodel.keyword, isEditing: self.$viewmodel.isEditing)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
             
                    if self.viewmodel.keyword.isEmpty {
                        HStack {
                            Text("라벨 목록").font(Font.B2_MEDIUM)
                                .foregroundColor(Color.PRIMARY_2)
                            Text("\(viewmodel.labels.count)")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color(hex: "257CCC"))
                                .padding(.leading, 4)

                        }.padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        FlexibleView(data: viewmodel.labels, spacing: 10, alignment: HorizontalAlignment.leading) { label in
                            Text(label.name)
                                .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                .font(Font.B1_REGULAR)
                                .foregroundColor(label.color.text)
                                .background(label.color.deactive)
                                .cornerRadius(3)
                                .onTapGesture {
                                    if !viewmodel.selectedLabels.contains(label) {
                                        viewmodel.selectedLabels.append(label)
                                    } else {
                                        if let index = self.viewmodel.selectedLabels.firstIndex(of: label) {
                                            self.viewmodel.selectedLabels.remove(at: index)
                                        }
                                    }
                                }
                        }.padding(.leading, 20)

                    } else {
                        if (viewmodel.labels.filter { label in label.name.contains(viewmodel.keyword) }.count) > 0 {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("검색 결과")
                                        .font(Font.B2_MEDIUM)
                                        .foregroundColor(Color.PRIMARY_2)
                                    Text("\(viewmodel.labels.filter { label in label.name.contains(viewmodel.keyword) }.count)")
                                        .font(Font.B2_MEDIUM)
                                        .foregroundColor(Color(hex: "257CCC"))
                                        .padding(.leading, 4)

                                }.padding(.leading, 20)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            VStack(alignment: .leading) {
                                Text("검색결과가 없습니다 ")
                                    .font(Font.B2_MEDIUM)
                                    .foregroundColor(Color.PRIMARY_2)
                                    .padding([.bottom, .leading], 20)

                                HStack {
                                    Text("\(viewmodel.keyword)").font(Font.system(size: 16))
                                        .foregroundColor(Color.PRIMARY_1)
                                        .offset(x: 8)

                                    NavigationLink(destination: AddNewLabelView(), isActive: $showAddLabelView) {
                                        Text("생성")
                                            .onTapGesture {
                                                self.showAddLabelView = true
                                            }

                                    }.foregroundColor(Color.KEY)
                                        .font(Font.B2_MEDIUM)
                                        .padding(8)
                                }
                                .background(Color.DEPTH_3)
                                .cornerRadius(2)
                                .border(Color.PRIMARY_4)
                                .offset(x: 20)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        FlexibleView(data: self.viewmodel.labels.filter { viewmodel.keyword.isEmpty ? true : $0.name.contains(viewmodel.keyword) }, spacing: 8, alignment: HorizontalAlignment.leading) {
                            label in Button(action: {
                                viewmodel.selectedLabels.insert(label, at: 0)
                            }) {
                                Text(verbatim: label.name)
                                    .padding(8)
                                    .background(giveLabelBackgroundColor(color: label.color))
                                    .foregroundColor(giveTextForegroundColor(color: label.color))
                            }
                        }.padding([.leading], 20)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("추가한 라벨")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color.PRIMARY_2)
                            Text("\(viewmodel.selectedLabels.count)")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color.KEY_ACTIVE)
                        }.padding([.leading, .top], 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewmodel.selectedLabels, id: \.self) { item in
                                    Badge(name: item.name, color: giveLabelBackgroundColor(color: item.color), textColor: giveTextForegroundColor(color: item.color), type: .removable {
                                        withAnimation {
                                            if let firstIndex = viewmodel.selectedLabels.firstIndex(of: item) {
                                                viewmodel.selectedLabels.remove(at: firstIndex)
                                            }
                                        }
                                    }).transition(.opacity)
                                }
                            }
                        }.padding(20)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 101)
                    .background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                    .opacity(viewmodel.selectedLabels.count > 0 ? 1 : 0)
                
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("ico_cancel")
                    })
                    Spacer(minLength: 100)
                    Text("스크린샷 라벨 편집")
                        .foregroundColor(Color.PRIMARY_1)
                        .font(Font.B1_REGULAR)
                    Spacer()
                }, trailing:
                HStack {
                    Button(action: {}, label: {
                        Text("완료")
                            .foregroundColor(Color.KEY_ACTIVE)
                            .font(Font.B1_MEDIUM)
                    })
                })
    }

    class ViewModel: ObservableObject {
        @Published var keyword: String = ""
        @Published var labels: [LabelEntity] = []
        @Published var selectedLabels: [LabelEntity] = []
        @Published var isEditing: Bool = false
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData())) // 모든 라벨들을 로드
        let cancelbag = CancelBag()

        init() {
            loadLabelingSelectData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: {
                data in
                self.labels = data
            }).store(in: cancelbag)
        }

        func colorSetToString(color: ColorSet) -> String {
            switch color {
            case .YELLOW:
                return "Yellow"
            case .RED:
                return "Red"
            case .VIOLET:
                return "Violet"
            case .BLUE:
                return "Blue"
            case .GREEN:
                return "Green"
            case .ORANGE:
                return "Orange"
            case .PINK:
                return "Pink"
            case .CONBALT_BLUE:
                return "Cobalt_Blue"
            case .PEACOCK_GREEN:
                return "Peacock_Green"
            case .GRAY:
                return "Gray"
            }
        }
    }
}
