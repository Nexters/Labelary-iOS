//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewmodel = ViewModel()
    @State private var show = false

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("홈")
                            .font(Font.H1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 0))
                        Spacer()
                        NavigationLink(
                            destination: SettingView(onFinished: {})
                        ) {
                            Image("ico_profile")
                        }

                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 60,
                            alignment: .topLeading)

                    Button(action: {
                        self.show = true
                    }) {
                        Text("스크린샷 검색".localized())
                            .foregroundColor(Color.PRIMARY_2)
                        NavigationLink(
                            destination: SearchScreenshotView(),
                            isActive: $show
                        ) {}
                    }
                    .frame(width: 360, height: 40, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .background(Color.DEPTH_3)
                    .cornerRadius(4)
                    .foregroundColor(Color.PRIMARY_2)
                    .font(Font.B1_REGULAR)
                    .overlay(
                        HStack {
                            Image("Icon_search")
                                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            Spacer()
                        }.padding(.horizontal, 9)
                    )

                    buildRecentSection(title: "최근 순 스크린샷".localized(), models: viewmodel.recentlyImages.filter { $0.status != .SELECTING }, isRecently: true)
                    buildLikeSection(title: "즐겨찾는 스크린샷".localized(), models: viewmodel.bookmarImages.filter { $0.status != .SELECTING }, isRecently: false)

                }.onAppear(perform: {
                    
                    viewmodel.refresh()
                    viewmodel.changeItems(recentlyImages: viewmodel.recentlyImages.filter { $0.status != .SELECTING }, bookmarkedImages: viewmodel.bookmarImages.filter { $0.status != .SELECTING })
                })
            }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    func buildLikeSection(title: String, models: [ImageViewModel], isRecently: Bool) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)
            Spacer()
            NavigationLink(destination: HomeDetailView(images: models.map { $0.image })) {
                Image("icon_arrow")
            }
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))
        if models.count == 0 {
            Image("SS_large_state")
                .resizable()
                .frame(width: 335, height: 195, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(models.indices, id: \.self) { i in
                        let model = models[i]
                        CScreenShotView(imageViewModel: model,
                                        nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: model, onChangeBookmark: viewmodel.onChangeBookMark), onChangeBookMark: viewmodel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                    }
                }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
            }
        }
    }

    @ViewBuilder
    func buildRecentSection(title: String, models: [ImageViewModel], isRecently: Bool) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)
            Spacer()
            NavigationLink(destination: HomeDetailRecentView(images: models.map { $0.image })) {
                Image("icon_arrow")
            }
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))

        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(models.indices, id: \.self) { i in
                    let model = models[i]
                    CScreenShotView(imageViewModel: model,
                                    nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: model, onChangeBookmark: viewmodel.onChangeBookMark), onChangeBookMark: viewmodel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                }
            }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
        }
    }

    private func onDeleteImage(id: String) {
        viewmodel.recentlyImages = viewmodel.recentlyImages.filter { $0.image.id != id }
    }

    class ViewModel: ObservableObject {
        @Published var recentlyImages: [ImageViewModel] = []
        @Published var bookmarImages: [ImageViewModel] = []

        @Published var keyword: String = ""
        @Published var labels: [LabelEntity] = []
        @Published var recentlySearchedLabels: [LabelEntity] = []
        @Published var selectedLabels: [LabelEntity] = []
        let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let loadSearchLabelData = LoadSearchLabelData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData())) // 최근 검색한 라벨
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData())) // 모든 라벨들을 로드

        let cancelbag = CancelBag()

        var cachedImages: [ImageEntity] = []

        init() {
            refresh()
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

        func changeItems(recentlyImages: [ImageViewModel], bookmarkedImages: [ImageViewModel]) {
            self.recentlyImages = recentlyImages
            bookmarImages = bookmarkedImages
        }

        func onAppear() {
            print("this is onappear function ")
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
