//
//  HomeDetail.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/15.
//

import Foundation
import SwiftUI

struct HomeDeatilView: View {
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
                        .padding(.leading, output.isEditing ? 18 : 20)
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

                ScrollView {
                    LazyVGrid(columns: columns) {
                        List(output.items.indices, id: \.self) { index in
                            let screenshot = $output.items[index]
                            CScreenShotView(screenshot: screenshot, nextView: ScreenShotDetailView(screenShot: screenshot.image), width: 102, height: 221)
                        }
                    }.padding(EdgeInsets(top: 20, leading: 13, bottom: 20, trailing: 13))
                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
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
        @Published var items: [ImageWrapper]

        init(images: [ImageEntity]) {
            items = images.map { ImageWrapper(imageEntity: $0, status: .IDLE) }
        }

        func changeItems(items: [ImageWrapper]) {
            self.items = items
        }
    }
}
