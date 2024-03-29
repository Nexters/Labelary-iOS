//
//  HomeDetailRecentView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/12.
//

import Foundation
import Photos
import SwiftUI

// 최근순 스크린샷
struct HomeDetailRecentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var output: Output
    @State private var showingAlert = false

    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(images: [ImageEntity]) {
        output = Output(images: images)
    }

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(self.output.isEditing ? "ico_cancel" : "ico_back")
                        .padding(.top, 13)
                        .padding(.leading, output.isEditing ? 20 : 20)
                        .onTapGesture {
                            if self.output.isEditing {
                                output.changeItems(items: self.output.items.filter { $0.status != .SELECTING })

                                for i in output.items.indices {
                                    self.output.items[i].status = .IDLE
                                }

                                self.output.isEditing = false
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    if !self.output.isEditing {
                        Text("최근 순 스크린샷".localized())
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(.top, 14)
                    }

                    Spacer()

                    if output.isEditing {
                        Image("ico_delete_active")
                            .padding(.top, 14)
                            .onTapGesture {
                                self.showingAlert.toggle()
                            }
                    } else {
                        Text("선택".localized())
                            .font(Font.B1_REGULAR)
                            .foregroundColor(Color.KEY_ACTIVE)
                            .padding(.top, 14)
                            .onTapGesture {
                                self.output.isEditing = true
                                for i in 0 ..< output.items.count {
                                    self.output.items[i].status = .EDITING
                                }
                            }
                    }
                }.padding(.trailing, 20)
                    .frame(minHeight: 60)
                Spacer()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(output.items.indices, id: \.self) { index in
                            let screenshot = output.items[index]
                            CScreenShotView(imageViewModel: screenshot,
                                            nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: onChangeBookMark), onChangeBookMark: onChangeBookMark, onDeleteImage: onDeleteImage), width: 110, height: 236)
                                .padding(.leading, 2)
                        }
                    }.padding(.leading, 20)
                        .padding(.trailing, 20)
                }
                Spacer()
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("스크린샷을 삭제하시겠어요?".localized()), message: Text("스크린샷은 레이블러리와 엘범애서 모두 삭제됩니다.".localized()), primaryButton: .default(Text("취소".localized())), secondaryButton: .destructive(Text("삭제".localized())) {
                    output.delete(images: self.output.items.filter { $0.status == .SELECTING })
                    output.deleteEntity(images: self.output.items.filter { $0.status == .SELECTING })
                    output.changeItems(items: self.output.items.filter { $0.status != .SELECTING })
                })
            }

        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: {
                output.refresh()
//                posthog?.capture("[02.Home]SearchResultView")
            })
    }

    private func onChangeBookMark(entity: ImageEntity) {
        let item = output.items.first(where: { $0.image.id == entity.id })
        if var items = item {
            items.image.isBookmark = entity.isBookmark
        }
    }

    /*
        private func onDeleteImage(index: Int) {
            output.items.remove(at: index)
        }
     */

    // 여기 고쳐야 함
    private func onDeleteImage(index: String) {
        output.items = output.items.filter { $0.image.id != index }
    }

    private func getRow(count: Int) -> Int {
        if count % 3 == 0 {
            return count / 3
        } else {
            return count / 3 + 1
        }
    }

    class VM: ViewModel {
        struct Input {
            let loadTrigger: Driver<Void>
            let reloadTrigger: Driver<Void>
            let loadMoreTrigger: Driver<Void>
            let selectRepoTrigger: Driver<IndexPath>
        }

        class Output: ObservableObject {
            @Published var isLoading = false
            @Published var isReloading = false
            @Published var isLoadingMore = false
            @Published var isEditing = false
            @Published var items: [Screenshot] = []
        }

        func transform(_ input: Input, cancelBag: CancelBag) -> Output {
            Output()
        }
    }

    class Output: ObservableObject {
        @Published var isLoading = false
        @Published var isReloading = false
        @Published var isLoadingMore = false
        @Published var isEditing = false
        @Published var items: [ImageViewModel]

        @Published var cachedImages: [ImageEntity] = []

        let cancelbag = CancelBag()
        let deleteImages = DeleteImages(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

        let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

        init(images: [ImageEntity]) {
            items = images.map { ImageViewModel(image: $0) }
        }

        func changeItems(items: [ImageViewModel]) {
            self.items = items
        }

        func refresh() {
            loadSearchMainData.get()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { data in
                        self.cachedImages = data.recentlyImages
                    }
                ).store(in: cancelbag)
        }

        // Photo library에서 직접 삭제하는 로직
        func delete(images: [ImageViewModel]) {
            for image in images {
                let asset = PHAsset.fetchAssets(withLocalIdentifiers: [image.image.source], options: nil).firstObject

                PHPhotoLibrary.shared().performChanges({ [self] in
                    print("imageentity id:", image.image.id)
                    PHAssetChangeRequest.deleteAssets([asset] as NSArray)
                }, completionHandler: { isDone, error in
                    print(isDone ? "success+++" : error.debugDescription)

                })
            }
        }

        func deleteEntity(images: [ImageViewModel]) {
            for image in images {
                deleteImages.get(param: [image.image]).sink(receiveCompletion: { _ in
                    print("Delete Entity done ! ")
                }, receiveValue: { data in
                    print("+++++++ delete Entity +++++", data)

                }).store(in: cancelbag)
            }
        }
    }
}
