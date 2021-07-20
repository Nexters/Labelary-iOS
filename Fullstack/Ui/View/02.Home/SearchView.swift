//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewmodel = ViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if !self.viewmodel.isEditing {
                    HStack(alignment: .firstTextBaseline) {
                        Text("홈")
                            .font(Font.H1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 0))
                        Spacer()
                        Image("ico_profile")
                            .padding(EdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 21))
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 60,
                            alignment: .topLeading)
                }

                SearchBar(keyword: self.$viewmodel.keyword, isEditing: self.$viewmodel.isEditing, labels: self.$viewmodel.selectedLabels)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                if self.viewmodel.isEditing {
                    buildSearchView(keyword: self.viewmodel.keyword)
                } else {
                    buildSection(title: "최근 순 사진", models: viewmodel.recentlyImages, isRecently: true)
                    buildSection(title: "즐겨찾는 스크린샷", models: viewmodel.bookmarImages, isRecently: false)
                }
            }.onAppear(perform: viewmodel.onAppear)
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }

    @ViewBuilder
    func buildSection(title: String, models: [ImageViewModel], isRecently: Bool) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)
            Spacer()
            NavigationLink(destination: HomeDeatilView(images: models.map { $0.image })) {
                Image("icon_arrow")
            }
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))

        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(models.indices, id: \.self) { i in
                    let model = models[i]
                    CScreenShotView(imageViewModel: model, nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: model, onChangeBookmark: viewmodel.onChangeBookMark), onChangeBookMark: viewmodel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                }
            }.padding(.leading, 16).padding(.trailing, 16)
        }
    }

    @ViewBuilder
    func buildSearchView(keyword: String) -> some View {
        if keyword.isEmpty {
            VStack(alignment: .leading) {
                Text("최근 검색한 라벨")
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
                            if !viewmodel.selectedLabels.contains(label) {
                                viewmodel.selectedLabels.append(label)
                            } else {
                                if let index = self.viewmodel.selectedLabels.firstIndex(of: label) {
                                    self.viewmodel.selectedLabels.remove(at: index)
                                }
                            }
                        }
                }

                HStack {
                    Text("내 라벨")
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
                    Text("검색결과")
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
    }

    private func onDeleteImage(id: String) {
        viewmodel.recentlyImages = viewmodel.recentlyImages.filter { $0.image.id != id }
    }

    class ViewModel: ObservableObject {
        @Published var recentlyImages: [ImageViewModel] = []
        @Published var bookmarImages: [ImageViewModel] = []
        @Published var isEditing: Bool = false
        @Published var keyword: String = ""
        @Published var labels: [LabelEntity] = [
            LabelEntity(id: "1", name: "OOTD", color: ColorSet.RED(), images: [], createdAt: Date()),
            LabelEntity(id: "2", name: "컬러팔레트", color: ColorSet.BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "3", name: "UI 레퍼런스", color: ColorSet.GREEN(), images: [], createdAt: Date()),
            LabelEntity(id: "4", name: "편집디자인", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "5", name: "채팅", color: ColorSet.CONBALT_BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "6", name: "meme 모음", color: ColorSet.YELLOW(), images: [], createdAt: Date()),
            LabelEntity(id: "7", name: "글귀", color: ColorSet.ORANGE(), images: [], createdAt: Date()),
            LabelEntity(id: "8", name: "장소(공연, 전시 등)", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "9", name: "영화", color: ColorSet.YELLOW(), images: [], createdAt: Date()),
            LabelEntity(id: "10", name: "네일", color: ColorSet.ORANGE(), images: [], createdAt: Date()),
            LabelEntity(id: "11", name: "맛집", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "12", name: "인테리어", color: ColorSet.GRAY(), images: [], createdAt: Date())
        ]

        @Published var selectedLabels: [LabelEntity] = []
        let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let cancelbag = CancelBag()

        var cachedImages: [ImageEntity] = []

        init() {
            refresh()
        }

        func refresh() {
            loadSearchMainData.get()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { data in
                        self.recentlyImages = data.recentlyImages.map { ImageViewModel(image: $0) }
                        self.bookmarImages = data.bookmarkedImages.map { ImageViewModel(image: $0) }
                    }
                ).store(in: cancelbag)
        }

        func onChangeBookMark(entity: ImageEntity) {
            cachedImages.append(entity)
        }

        func onAppear() {
            print("onAppear\(cachedImages)")
            cachedImages.forEach { entity in
                if entity.isBookmark {
                    if !bookmarImages.contains(where: { $0.image.id == entity.id }) {
                        if let item = recentlyImages.first(where: { $0.image.id == entity.id }) {
                            item.image = entity
                            bookmarImages.insert(item, at: 0)
                            item.reload()
                        }
                    }
                } else {
                    if let item = recentlyImages.first(where: { $0.image.id == entity.id }) {
                        item.image = entity
                        item.reload()
                    }
                    bookmarImages.removeAll(where: { $0.image.id == entity.id })
                }
            }
            cachedImages = []
        }
    }
}
