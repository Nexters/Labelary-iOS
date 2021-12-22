//
//  AlbumSelectView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/28.
//

import SwiftUI
// 스크린샷 선택된 이미지들
class PassImageData: ObservableObject {
    @Published var selectedImages: [ImageEntity] = []
}

var passingImageEntity = PassImageData()

struct AlbumSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImages: [ImageEntity] = []
    @State private var onTapped: Bool = false
    @ObservedObject private var viewModel = ViewModel()
    @State private var showEditView: Bool = false

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
                            AlbumGridItem(selectedImages: $selectedImages, screenshot: screenshot, img: viewModel.cachedImages[i])
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    // Cancel Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        passingImageEntity.selectedImages.removeAll()
                    }) { Image("ico_cancel") }
                    
                    Text("\(selectedImages.count)개")
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .opacity(selectedImages.count > 0 ? 1 : 0)
                    
                },
                trailing: HStack {
                    // 라벨 수정하기 -> 스크린샷 라벨 변경 화면으로 이동
                    
                    Button(action: {
                        
                        passingImageEntity.selectedImages.append(contentsOf: selectedImages)
                        showEditView = true
                    }) {
                        selectedImages.count > 0 ?
                            Image("ico_label_edit_active") : Image("ico_label_edit_inactive")
                    }.disabled(selectedImages.count > 0 ? false : true).padding()
                    
                    NavigationLink(destination: AlbumEditLabelView(), isActive: $showEditView) {}
                
                    // 이미지 삭제하기
                    Button(action: {
                        viewModel.deleteImageFromLabel.get(param: selectedImages).sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: viewModel.cancelBag)
                     
                    }) {
                        selectedImages.count > 0 ?
                            Image("ico_delete_active") : Image("ico_delete_inactive")
                    }.disabled(selectedImages.count > 0 ? false : true)
                })
    }
    
    class ViewModel: ObservableObject {
        @Published var cachedImages: [ImageEntity] = []
        @Published var labelImages: [LabelImageEntity] = []
        @Published var screenshots: [ImageViewModel] = []
        @Published var currentLabel: [LabelEntity] = []
   
        let loadAlbumData = LoadAlbumData(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))
        
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        
        let deleteImageFromLabel = DeleteImageFromLabel(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        
        let cancelBag = CancelBag()
    
        init() {
            loadAlbumData.get(param: passingLabelEntity.selectedLabel!).sink(receiveCompletion: { _ in }, receiveValue: {
                [self] data in
                self.labelImages.append(contentsOf: data)
                
            }).store(in: cancelBag)
            
            for data in labelImages {
                cachedImages.append(data.image)
            }
            setImages(images: cachedImages)
            currentLabel.append(passingLabelEntity.selectedLabel!)
        }
    
        func setImages(images: [ImageEntity]) {
            screenshots = images.map {
                ImageViewModel(image: $0)
            }
        }
    }
}
