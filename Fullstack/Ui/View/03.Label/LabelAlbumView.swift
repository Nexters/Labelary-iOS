//
//  LabelAlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import SwiftUI

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
        if passingLabelEntity.selectedLabel?.images.count == 0 {
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
                            // 최신순으로 정렬
                        }) {
                            LabelBadge(name: "최신순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(firstOption ? 1 : 0), textColor: firstOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                                .font(Font.B2_MEDIUM)
                                .padding(.bottom, 8)
                        }.offset(x: 20)

                        Button(action: {
                            firstOption = false
                            secondOption = true
                            thirdOption = false
                            // 오래본순으로 정렬
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
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 25) {
                            Button(action: {}) {
                                Image("SS_large_state_\(colorToString(color: passingLabelEntity.selectedLabel!.color))")
                                    .resizable()
                                    .frame(width: 102, height: 221)
                            }

                            ForEach(viewModel.screenshots.indices, id: \.self) { i in
                                let screenshot = viewModel.screenshots[i]

                                AlbumScreenShotView(imageViewModel: screenshot, width: 102, height: 221, nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: viewModel.onChangeBookMark), onChangeBookMark: viewModel.onChangeBookMark, onDeleteImage: onDeleteImage))
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
                            Text("\(passingLabelEntity.selectedLabel!.name)").font(Font.B1_BOLD)
                                .foregroundColor(Color.PRIMARY_1)
                        },
                        trailing:
                        Button(action: {}) {
                            Text("선택").font(Font.B1_BOLD)
                                .foregroundColor(giveActiveColor(color: passingLabelEntity.selectedLabel!.color))
                        })

            }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
        }
    }

    private func onDeleteImage(id: String) {
        viewModel.recentlyImages = viewModel.recentlyImages.filter { $0.image.id != id }
    }

    class ViewModel: ObservableObject {
        @Published var data = passingLabelEntity.selectedLabel?.images
        @Published var screenshots: [ImageViewModel] = []

        @Published var recentlyImages: [ImageViewModel] = []
        @Published var bookmarkImages: [ImageViewModel] = []

        let cancelBag = CancelBag()

        var cachedImages: [ImageEntity] = []

        let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

        init() {
            refresh()
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
