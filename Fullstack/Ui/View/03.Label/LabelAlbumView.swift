//
//  LabelAlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import SwiftUI

// 라벨 컬러별 앨범 UI

struct LabelAlbumView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstOption = true
    @State private var secondOption = false
    @State private var thirdOption = false
    @ObservedObject var viewModel = ViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        if viewModel.labelImageDict[passingLabelEntity.selectedLabel!]!.count == 0 {
            AlbumEmptyView()
        } else {
            ZStack {
                Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            firstOption = true
                            secondOption = false
                            thirdOption = false
                        }) {
                            LabelBadge(name: "최신순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(firstOption ? 1 : 0), textColor: firstOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                                .font(Font.B2_MEDIUM)
                                .padding(.bottom, 8)
                        }.offset(x: 20)

                        Button(action: {
                            firstOption = false
                            secondOption = true
                            thirdOption = false

                        }) {
                            LabelBadge(name: "오래본순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(secondOption ? 1 : 0), textColor: secondOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                                .font(Font.B2_MEDIUM)
                                .padding(.bottom, 8)
                        }.offset(x: 20)

                        Button(action: {
                            firstOption = false
                            secondOption = false
                            thirdOption = true
                            // 자주 본 순으로 정렬
                        }) {
                            LabelBadge(name: "자주본순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(thirdOption ? 1 : 0), textColor: thirdOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                                .font(Font.B2_MEDIUM)
                                .padding(.bottom, 8)
                        }.offset(x: 20)
                        Spacer()
                    }
                    Spacer()
                    if firstOption == true {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 25) {
                                NavigationLink(destination: EditAlbumView()) {
                                    Image("SS_large_state_\(colorToString(color: passingLabelEntity.selectedLabel!.color))")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 102, height: 221)
                                }

                                ForEach(viewModel.screenshots.indices, id: \.self) { i in
                                    let screenshot = viewModel.screenshots[i]
                                    CScreenShotView(imageViewModel: screenshot,
                                                    nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: viewModel.onChangeBookMark), onChangeBookMark: viewModel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                                }
                            }
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 25) {
                                NavigationLink(destination: EditAlbumView()) {
                                    Image("SS_large_state_\(colorToString(color: passingLabelEntity.selectedLabel!.color))")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 102, height: 221)
                                }

                                ForEach(viewModel.oldScreenshots.indices, id: \.self) { i in
                                    let screenshot = viewModel.oldScreenshots[i]
                                    CScreenShotView(imageViewModel: screenshot,
                                                    nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: viewModel.onChangeBookMark), onChangeBookMark: viewModel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                                }
                            }
                        }
                    }
                }.onAppear(perform: viewModel.onAppear)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading:
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("navigation_back_btn")
                            }
                            Text("\(passingLabelEntity.selectedLabel!.name)")
                                .font(Font.B1_BOLD)
                                .foregroundColor(Color.PRIMARY_1)
                        },
                        trailing:
                        HStack {
                            NavigationLink(destination: AlbumSelectView()) {
                                Text("선택").font(Font.B1_REGULAR)
                                    .foregroundColor(giveActiveColor(color: passingLabelEntity.selectedLabel!.color))
                            }
                        })

            }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
        }
    }

    private func onDeleteImage(id: String) {
        viewModel.recentlyImages = viewModel.recentlyImages.filter { $0.image.id != id }
    }

    class ViewModel: ObservableObject {
        @Published var screenshots: [ImageViewModel] = []
        @Published var oldScreenshots: [ImageViewModel] = []
        @Published var recentlyImages: [ImageViewModel] = []
        @Published var bookmarkImages: [ImageViewModel] = []
        @Published var tempOldLabelImages: [LabelImageEntity] = []
        @Published var labelImageDict: [LabelEntity: [LabelImageEntity]] = [:]

        let cancelBag = CancelBag()

        var cachedImages: [ImageEntity] = [] // 최신순
        var cachedOldImages: [ImageEntity] = []

        let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let loadAlbumData = LoadAlbumData(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        // 자주본순, 오래본순 정렬
        let loadOldLabeledImage = LoadOldLabeledImage(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        init() {
            if passingLabelEntity.selectedLabel != nil {
                loadAlbumData.get(param: passingLabelEntity.selectedLabel!).sink(receiveCompletion: { _ in }, receiveValue: {
                    [self] data in labelImageDict[passingLabelEntity.selectedLabel!] = data
                }).store(in: cancelBag)

                for data in labelImageDict[passingLabelEntity.selectedLabel!]! {
                    cachedImages.append(data.image)
                }

                loadOldLabeledImage.get(param: labelImageDict[passingLabelEntity.selectedLabel!]!).sink(receiveCompletion: { _ in }, receiveValue: {
                    [self] data in
                    tempOldLabelImages.append(contentsOf: data)
                }).store(in: cancelBag)

                for entity in tempOldLabelImages {
                    cachedOldImages.append(entity.image)
                }
            } else {
                print("passing label entity is empty !! /n")
            }

            refresh()
            screenshots = setImages(data: cachedImages)
            oldScreenshots = setOldImages(data: cachedOldImages)
        }

        func refresh() {
            loadSearchMainData.get()
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    data in
                    self.recentlyImages = data.recentlyImages.map {
                        ImageViewModel(image: $0)
                    }
                    self.bookmarkImages = data.bookmarkedImages.map {
                        ImageViewModel(image: $0)
                    }
                }).store(in: cancelBag)
        }

        func setOldImages(data: [ImageEntity]) -> [ImageViewModel] {
            oldScreenshots = data.map {
                ImageViewModel(image: $0)
            }
            return oldScreenshots
        }

        func setImages(data: [ImageEntity]) -> [ImageViewModel] {
            screenshots = data.map {
                ImageViewModel(image: $0)
            }
            return screenshots
        }

        func onChangeBookMark(entity: ImageEntity) {
            cachedImages.append(entity)
        }

        func onAppear() {
            print("onAppear\(cachedImages)")
            cachedImages.forEach { entity in
                if entity.isBookmark {
                    if !bookmarkImages.contains(where: { $0.image.id == entity.id }) {
                        if let item = recentlyImages.first(where: { $0.image.id == entity.id }) {
                            item.image = entity
                            bookmarkImages.insert(item, at: 0)
                            item.reload()
                        }
                    }
                } else {
                    if let item = recentlyImages.first(where: { $0.image.id == entity.id }) {
                        item.image = entity
                        item.reload()
                    }
                    bookmarkImages.removeAll(where: { $0.image.id == entity.id })
                }
            }
            cachedImages = []
        }
    }
}
