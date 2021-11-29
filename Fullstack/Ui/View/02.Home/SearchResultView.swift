//
//  SearchResultView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/29.
//

import SwiftUI

struct SearchResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(searchSelectedLabels.selectedLabels, id: \.self) { item in
                            Badge(name: item.name, color: giveLabelBackgroundColor(color: item.color), textColor: giveTextForegroundColor(color: item.color), type: .removable {
                                withAnimation {
                                    if let firstIndex = searchSelectedLabels.selectedLabels.firstIndex(of: item) {
                                        searchSelectedLabels.selectedLabels.remove(at: firstIndex)
                                    }
                                }
                            }).transition(.opacity)
                        }
                    }.padding(15)
                }
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("편집").foregroundColor(Color.KEY_ACTIVE)
                })
            }
            Spacer()

            HStack {
                Text("스크린샷 검색 결과").font(Font.B2_MEDIUM)
                Text("\(viewModel.screenshots.count)").foregroundColor(Color.KEY_ACTIVE).font(Font.B2_MEDIUM) // 결과에 해당하는 스크린샷 개수
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(viewModel.screenshots.indices, id: \.self) { i in
                        let screenshot = viewModel.screenshots[i]
                        CScreenShotView(imageViewModel: screenshot, nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: viewModel.onChangeBookMark), onChangeBookMark: viewModel.onChangeBookMark, onDeleteImage: onDeleteImage), width: 90, height: 195)
                    }
                }
            }

        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack {
                Button(action: {
                    searchSelectedLabels.selectedLabels = [] // default 값으로 바꿔준다
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("ico_cancel")
                })

                Text("검색한 스크린샷").padding(.leading, 20)
            }
            )
    }

    private func onDeleteImage(id: String) {
        viewModel.recentlyImages = viewModel.recentlyImages.filter { $0.image.id != id }
    }

    class ViewModel: ObservableObject {
        @Published var recentlyImages: [ImageViewModel] = []
        @Published var screenshots: [ImageViewModel] = []
        @Published var labelImageData: [LabelImageEntity] = []
        var cachedImages: [ImageEntity] = []

        let cancelBag = CancelBag()
        let searchImageByLabel = SearchImageByLabel(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        init() {
            searchImageByLabel.get(param: searchSelectedLabels.selectedLabels).sink(receiveCompletion: { _ in }, receiveValue: {
                [self] data in labelImageData.append(contentsOf: data)
            }).store(in: cancelBag)

            screenshots = setImages(data: labelImageData)
        }

        // 전달된 labels을 '모두 포함하고 있는 검색결과

        func setImages(data: [LabelImageEntity]) -> [ImageViewModel] {
            screenshots = data.map {
                ImageViewModel(image: $0.image)
            }
            return screenshots
        }

        func onChangeBookMark(entity: ImageEntity) {
            cachedImages.append(entity)
        }
    }
}
