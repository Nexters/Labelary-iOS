//
//  SearchScreenshotView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/28.
//

import SwiftUI

class neededLabelForSearch: ObservableObject {
    @Published var selectedLabels: [LabelEntity] = []
}

var searchSelectedLabels = neededLabelForSearch()

struct SearchScreenshotView: View {
    @State private var keyword: String = ""
    @ObservedObject var viewmodel = ViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showResultView: Bool = false

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                SearchBar(keyword: self.$viewmodel.keyword, isEditing: self.$viewmodel.isEditing)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 20, trailing: 0))
      
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewmodel.selectedLabels, id: \.self) { item in
                            Badge(name: item.name, color: giveLabelBackgroundColor(color: item.color), borderColor: giveBorderColor(color: item.color), textColor: giveTextForegroundColor(color: item.color), type: .removable {
                                withAnimation {
                                    if let firstIndex = viewmodel.selectedLabels.firstIndex(of: item) {
                                        viewmodel.selectedLabels.remove(at: firstIndex)
                                    }
                                }
                            }).transition(.opacity)
                        }
                    }
                }.padding(15)
                
                if !viewmodel.isEditing {
                    VStack(alignment: .leading) {
                        Text("최근 검색한 라벨".localized())
                            .font(Font.B2_MEDIUM)
                            .foregroundColor(Color.PRIMARY_2)

                        FlexibleView(data: viewmodel.labels.prefix(5), spacing: 10, alignment: HorizontalAlignment.leading) { label in
                            Text(label.name)
                                .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                .font(Font.B1_REGULAR)
                                .foregroundColor(label.color.text)
                                .background(label.color.deactive)
                                .cornerRadius(3)
                                .onTapGesture {
                                    if !viewmodel.recentlySearchedLabels.contains(label) {
                                        viewmodel.recentlySearchedLabels.append(label)
                                    } else {
                                        if let index = self.viewmodel.recentlySearchedLabels.firstIndex(of: label) {
                                            self.viewmodel.recentlySearchedLabels.remove(at: index)
                                        }
                                    }
                                }
                        }

                        HStack {
                            Text("라벨 목록".localized())
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color.PRIMARY_2)

                            Text("\(viewmodel.labels.count)")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color(hex: "257CCC"))
                                .padding(.leading, 4)
                        }.padding(.top, 40)
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
                        }
                    }.padding(20)
                } else {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("검색결과".localized())
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color.PRIMARY_2)

                            Text("\(viewmodel.labels.filter { label in label.name.contains(keyword) }.count)")
                                .font(Font.B2_MEDIUM)
                                .foregroundColor(Color(hex: "257CCC"))
                                .padding(.leading, 4)
                        }.padding(.top, 40)
                        
                        FlexibleView(data: viewmodel.labels.filter { label in label.name.contains(keyword) }, spacing: 10, alignment: HorizontalAlignment.leading) { label in
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
                        }
                    }.padding(20)
                }

                Spacer(minLength: 20)
                Button(action: {
                    // 검색 결과 화면으로 이동
                    posthog?.capture("[02.Home] Show Result View Button touched")
                    searchSelectedLabels.selectedLabels.removeAll()
                    searchSelectedLabels.selectedLabels.append(contentsOf: viewmodel.selectedLabels)
                    self.showResultView = true
                }) {
                    Image(viewmodel.selectedLabels.count > 0 ? "ico_search_screenshot_active" : "ico_search_screenshot_inactive")
                        .frame(width: 335, height: 54, alignment: .center).padding([.leading, .trailing], 18)
                    NavigationLink(destination: SearchResultView(), isActive: $showResultView) {}
                }.disabled(viewmodel.selectedLabels.count == 0)
                    .padding(.leading, 10)
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("ico_cancel")
                    })
                    Spacer(minLength: 120)
                    Text("스크린샷 검색".localized())
                        .foregroundColor(Color.PRIMARY_1)
                        .font(Font.B1_REGULAR)
                    Spacer()
                }
            )
    }

    class ViewModel: ObservableObject {
        @Published var labels: [LabelEntity] = []
        @Published var recentlySearchedLabels: [LabelEntity] = []
        @Published var selectedLabels: [LabelEntity] = []
        @Published var isEditing: Bool = false
        @Published var keyword: String = ""
        let loadSearchLabelData = LoadSearchLabelData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        // 최근 검색한 라벨
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData())) // 모든 라벨들을 로드
        let cancelbag = CancelBag()
        

        init() {
            loadLabelingSelectData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: {
                data in
                self.labels = data
            }).store(in: cancelbag)

            loadSearchLabelData.get().sink(receiveCompletion: { _ in }, receiveValue: { data in
                self.recentlySearchedLabels = data.recentlySearchedLabels
            }).store(in: cancelbag)
        }
    }
}
