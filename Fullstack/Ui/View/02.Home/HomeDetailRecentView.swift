//
//  HomeDetailRecentView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/12.
//

import Foundation
import SwiftUI

// 최근순 스크린샷
struct HomeDetailRecentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var output: Output

    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

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
                                self.output.isEditing = false
                                for i in output.items.indices {
                                    self.output.items[i].status = .IDLE
                                }
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    if !self.output.isEditing {
                        Text("최근 순 스크린샷")
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(.top, 14)
                    }

                    Spacer()

                    if output.isEditing {
                        Image("ico_delete_active")
                            .padding(.top, 14)
                            .onTapGesture {
                                output.changeItems(items: self.output.items.filter { $0.status != .SELECTING })
                            }
                    } else {
                        Text("선택")
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
                    LazyVGrid(columns: columns) {
                        ForEach(output.items.indices, id: \.self) { index in
                            let screenshot = output.items[index]

                            CScreenShotView(imageViewModel: screenshot,
                                            nextView: ScreenShotDetailView(viewmodel: ScreenShotDetailView.ViewModel(imageViewModel: screenshot, onChangeBookmark: onChangeBookMark), onChangeBookMark: onChangeBookMark, onDeleteImage: onDeleteImage), width: 102, height: 221)
                                .padding(.bottom, 8)
                        }
                    } .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
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

        init(images: [ImageEntity]) {
            items = images.map { ImageViewModel(image: $0) }
        }

        func changeItems(items: [ImageViewModel]) {
            self.items = items
        }
    }
}
