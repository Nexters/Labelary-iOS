//
//  EditAlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/10/09.
//

import SwiftUI

struct AlbumGridItem: View {
    @Binding var selectedImages: [ImageEntity]
    @State private var isSelected: Bool = false
    var screenshot: ImageViewModel
    var img: ImageEntity

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.isSelected.toggle()
                if isSelected {
                    selectedImages.append(img)
                } else {
                    if let firstIndex = selectedImages.firstIndex(of: img) {
                        selectedImages.remove(at: firstIndex)
                    }
                }

            }, label: {
                EditingScreenShotView(imageViewModel: screenshot, width: 102, height: 221)

            })
            self.isSelected ? Image("btn_check_active").offset(x: -10, y: 30) : Image("btn_check").offset(x: -10, y: 30)
        }
    }
}

// 스크린샷 추가하기 버튼 누르면 나오는 화면

struct EditAlbumView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImages: [ImageEntity] = []
    @ObservedObject private var viewModel = ViewModel()
    @State private var onTapped: Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    // Grid View
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(viewModel.screenshots.indices, id: \.self) { i in
                            let screenshot = viewModel.screenshots[i]
                            AlbumGridItem(selectedImages: $selectedImages, screenshot: screenshot, img: viewModel.unlabeledImages[i])
                        }
                    }
                }
            }.navigationBarBackButtonHidden(true)

                .navigationBarItems(leading:
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("btn_cancel")
                        })

                        Text("\(selectedImages.count)개")
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .opacity(selectedImages.count > 0 ? 1 : 0)
                    },
                    trailing: HStack {
                        Button(action: {
                            // request lable
                            viewModel.requestLabeling.get(param: RequestLabeling.Param.init(labels: viewModel.currentLabel, images: selectedImages))

                        }, label: {
                            Text("스크린샷 추가")
                                .font(Font.B1_BOLD)
                                .foregroundColor(Color.KEY_ACTIVE)
                        })
                    })
        }
    }

    class ViewModel: ObservableObject {
        let loadLabelingData = LoadLabelingData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
       
        let cancelBag = CancelBag()
        @Published var unlabeledImages: [ImageEntity] = []
        @Published var screenshots: [ImageViewModel] = []
        @Published var currentLabel: [LabelEntity] = []

        init() {
            loadLabelingData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: { [self] data in
                self.unlabeledImages.append(contentsOf: data)
                self.setImages(unlabeledImages: unlabeledImages)
            }).store(in: cancelBag)
            currentLabel.append(passingLabelEntity.selectedLabel)
        }

        func setImages(unlabeledImages: [ImageEntity]) {
            screenshots = unlabeledImages.map {
                ImageViewModel(image: $0)
            }
        }
    }
}
