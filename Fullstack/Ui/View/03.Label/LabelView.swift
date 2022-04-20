//
//  AlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import Combine
import SwiftUI

class PassLabelData: ObservableObject {
    @Published var selectedLabel: LabelEntity?
}

var passingLabelEntity = PassLabelData()

class Trigger: ObservableObject {
    @Published var isEmpty: Bool = true
}

struct LabelView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var labels: [LabelEntity] = []
    @State private var pushView = false
    @State private var showEditLabelView = false
    @State private var showingPopover = false
    @State private var showingAlert = false
    @State private var showLabelAlbumView = false
    @State private var showAlbumLabelView: Bool = false
    let cancelBag = CancelBag()

    var emptyView: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("ico_empty_album")
                    .padding(40)
                Text("라벨이 없습니다.".localized())
                    .font(Font.H3_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .padding(14)
                VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                    Text("라벨을 생성하여 스크린샷에".localized())
                    Text("라벨을 추가해보세요.".localized())
                }
                .font(Font.B1_REGULAR)
                .foregroundColor(Color.PRIMARY_2)

                Button(action: {
                    self.showAlbumLabelView = true
                }, label: {
                    Text("라벨 생성하기".localized())
                        .frame(minWidth: 160, maxWidth: 160, minHeight: 48, maxHeight: 48, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(4.0)
                }).offset(y: 60)
                    .sheet(isPresented: self.$showAlbumLabelView, content: {
                        AlbumAddLabelView()
                    })

                Spacer().frame(height: 269)
            }
        }
    }

    var sheetView: some View {
        ActionSheetCard(isShowing: $showingPopover, items: [
            ActionSheetCardItem(label: "라벨 수정하기".localized(), labelFont: Font.B1_BOLD, foregroundColor: Color.white) {
                showEditLabelView.toggle()
                passingLabelEntity.selectedLabel = viewModel.selectedLabel

            },
            ActionSheetCardItem(label: "라벨 삭제하기".localized(), labelFont: Font.B1_BOLD, foregroundColor: Color.white) {
                showingAlert.toggle()
            }
        ],
        backgroundColor: Color.DEPTH_2)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("라벨을 삭제하시겠어요?".localized()),
                      message: Text("해당 라벨을 삭제해도\n 라벨이 추가된 스크린샷은 삭제되지 않습니다.".localized()),
                      primaryButton: .default(Text("취소".localized())),
                      secondaryButton: .default(Text("삭제".localized())) {
                          // 삭제 로직

                          viewModel.deleteLabel.get(param: viewModel.selectedLabel!)
                              .sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: cancelBag)
                          viewModel.refresh()

                      })
            }
    }

    var content: some View {
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("라벨".localized())
                        .font(Font.H1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                    Spacer()

                    NavigationLink(destination: LabelDetailView(), label: {
                        Image("ico_add_album")
                    })
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 16))
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 60,
                        maxHeight: 60,
                        alignment: .topLeading)
                    .padding(.bottom, 20)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(self.viewModel.labels.indices, id: \.self) { i in
                            let label = self.viewModel.labels[i]
                            buildLabelView(label: label)
                        }
                    }.padding(EdgeInsets(top: 20, leading: 13, bottom: 20, trailing: 13))
                }
            }

        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear(perform: {
                self.viewModel.refresh()
            })
    }

    var body: some View {
        VStack {
            if self.labels.isEmpty {
                emptyView
            } else {
                ZStack {
                    content
                    sheetView
                    NavigationLink(destination: LabelAlbumView(), isActive: $showLabelAlbumView, label: {})
                }.sheet(isPresented: self.$showEditLabelView) {
                    ShowEditLabelView()
                }
            }
        }.onAppear(perform: {
            self.labels = viewModel.labels
//            posthog?.capture("[03.Album]LabelView")
        })
    }

    @ViewBuilder
    func buildLabelView(label: LabelEntity) -> some View {
        VStack(alignment: .leading) {
            if viewModel.labelImageDict[label]?.count == 0 {
                ZStack {
                    Button(action: {
                        viewModel.selectedLabel = label
                        passingLabelEntity.selectedLabel = label
                        showLabelAlbumView = true
                    }, label: {
                        Image("container_album")
                    })

                    Button(action: {
                        viewModel.selectedLabel = label
                        passingLabelEntity.selectedLabel = label

                    }, label: {
                        Image("ico_more")
                            .onTapGesture {
                                viewModel.selectedLabel = label
                                passingLabelEntity.selectedLabel = label
                                showingPopover = true
                            }
                    })
                        .padding(.leading, 115)
                        .padding(.bottom, 115)

                }.frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160, alignment: .center).background(Color.DEPTH_3)
            } else {
                ZStack {
                    Button(action: {
                        viewModel.selectedLabel = label
                        passingLabelEntity.selectedLabel = label
                        showLabelAlbumView = true
                    }, label: {
                        AlbumThumbnailView(imageViewModel: viewModel.setImages(labelImage: (viewModel.labelImageDict[label]?.first)!), width: 160, height: 160)
                    })

                    Button(action: {
                        viewModel.selectedLabel = label
                        passingLabelEntity.selectedLabel = label

                    }, label: {
                        Image("ico_more")
                            .onTapGesture {
                                viewModel.selectedLabel = label
                                passingLabelEntity.selectedLabel = label
                                showingPopover = true
                            }
                    })
                        .padding(.leading, 115)
                        .padding(.bottom, 115)

                }.frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160, alignment: .center)
            }

            LabelBadge(name: label.name, color: giveLabelBackgroundColor(color: label.color), textColor: giveTextForegroundColor(color: label.color))
                .font(Font.B2_MEDIUM)
                .padding(.bottom, 8)

            Text("\(viewModel.labelImageDict[label]!.count)").font(Font.B3_MEDIUM).padding(.bottom, 15).foregroundColor(Color.PRIMARY_2)
        }.padding(.leading, 7).padding(.trailing, 7).padding(.bottom, 8)
    }

    class ViewModel: ObservableObject {
        @Published var screenshots: [ImageEntity] = []
        @Published var labels: [LabelEntity] = []
        @Published var selectedLabel: LabelEntity?

        // dictionary 타입으로 만들어주기
        @Published var labelImageDict: [LabelEntity: [LabelImageEntity]] = [:]

        @Published var labelImageData: [LabelImageEntity] = [] // 여기서 이미지를 꺼낼거임

        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))

        let loadAlbumData = LoadAlbumData(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        // delete label
        let deleteLabel = DeleteLabel(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        // delete Image data
        let deleteLabelFromImage = DeleteLabelFromImage(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

        init() {
            refresh()
        }

        func refresh() {
            let cancelBag = CancelBag()

            loadLabelingSelectData.get().sink(receiveCompletion: {
                _ in
            }, receiveValue: {
                [self] data in
                self.labels = data
            }).store(in: cancelBag)

            // label 별로 분류를 해야하는뎅
            for label in labels {
                loadAlbumData.get(param: label).sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
                    self.labelImageDict[label] = data
                }).store(in: cancelBag)
            }
        }

        // image 들을 label별로 분류해야 한다.
        func setImages(labelImage: LabelImageEntity) -> ImageViewModel {
            return ImageViewModel(image: labelImage.image)
        }
    }
}
