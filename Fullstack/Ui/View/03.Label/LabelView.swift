//
//  AlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct LabelView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var pushView = false
    @State private var showingPopover = false

    var sheetView: some View {
        ActionSheetCard(isShowing: $showingPopover, items: [
            ActionSheetCardItem(label: "라벨 수정하기", labelFont: Font.B1_BOLD, foregroundColor: Color.white),
            ActionSheetCardItem(label: "라벨 삭제하기", labelFont: Font.B1_BOLD, foregroundColor: Color.white)
        ],
        backgroundColor: Color.DEPTH_2)
    }

    var content: some View {
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("라벨")
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
        ZStack {
            content
            sheetView   
        }
    }

    @ViewBuilder
    func buildLabelView(label: LabelEntity) -> some View {
        VStack(alignment: .leading) {
            if label.images.isEmpty {
                ZStack {
                    Image("container_album")
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Image("ico_more")
                    })
                        .padding(.leading, 115)
                        .padding(.bottom, 115)

                }.frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160, alignment: .center).background(Color.DEPTH_3)
            } else {
                Image(label.images.first!.id)
                    .frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160)
            }

            Text(label.name).font(Font.B2_MEDIUM).padding(.bottom, 8).foregroundColor(Color.PRIMARY_1)

            Text("\(label.images.count)").font(Font.B3_MEDIUM).padding(.bottom, 15).foregroundColor(Color.PRIMARY_2)
        }.padding(.leading, 7).padding(.trailing, 7).padding(.bottom, 8)
    }

    class ViewModel: ObservableObject {
        @Published var screenshots: [ImageEntity] = []
        @Published var labels: [LabelEntity] = []

        let searchImageByLabel = SearchImageByLabel(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))

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
        }
    }
}
