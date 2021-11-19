//
//  AlbumSelectView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/28.
//

import SwiftUI
// 스크린샷 선택
struct AlbumSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImages: [ImageEntity] = []
    @State private var onTapped: Bool = false
    @ObservedObject private var viewModel = ViewModel()

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
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(viewModel.screenshots.indices, id: \.self) { i in
                            let screenshot = viewModel.screenshots[i]
                            AlbumGridItem(selectedImages: $selectedImages, screenshot: screenshot, img: viewModel.unlabeledImages[i])
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) { Image("ico_cancel") }
                    
                    Text("\(selectedImages.count)개")
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .opacity(selectedImages.count > 0 ? 1 : 0)
                    
                },
                trailing: HStack {
                    // 라벨 수정하기 -> 스크린샷 라벨 변경 화면으로 이동
                    NavigationLink(destination: AlbumEditLabelView()) {
                        selectedImages.count > 0 ?
                            Image("ico_label_edit_active") : Image("ico_label_edit_inactive")
                        
                    }.disabled(selectedImages.count > 0 ? true : false)
              
                    // 이미지 삭제하기
                    Button(action: {
                        viewModel.requestDeleteImage(selectedImages: selectedImages)
                    }) {
                        selectedImages.count > 0 ?
                            Image("ico_delete_active") : Image("ico_delete_inactive")
                    }.disabled(selectedImages.count > 0 ? true : false)
                })
    }
    
    class ViewModel: ObservableObject {
        let deleteImage = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
    
        @Published var unlabeledImages: [ImageEntity] = []
        @Published var screenshots: [ImageViewModel] = []
        @Published var currentLabel: [LabelEntity] = []
   
        let loadLabelingData = LoadLabelingData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let cancelBag = CancelBag()
    
        init() {
            loadLabelingData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: { [self] data in
                self.unlabeledImages.append(contentsOf: data)
                self.setImages(unlabeledImages: unlabeledImages)
            }).store(in: cancelBag)
            currentLabel.append(passingLabelEntity.selectedLabel!)
        }
    
        func setImages(unlabeledImages: [ImageEntity]) {
            screenshots = unlabeledImages.map {
                ImageViewModel(image: $0)
            }
        }
        
        func requestDeleteImage(selectedImages: [ImageEntity]) {
            deleteImage.get(param: selectedImages).sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: cancelBag)
        }
    }
}
