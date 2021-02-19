//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var output = Output()
    let loadSearchMainData = LoadSearchMainData(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

    init() {
        let cancelbag = CancelBag()
        loadSearchMainData.get()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] data in
                    output.setImages(recentlyImages: data.recentlyImages, bookmarkImages: data.bookmarkedImages)
                }
            ).store(in: cancelbag)
    }

    var body: some View {
        ScrollView {
            VStack {
                if !self.output.isEditing {
                    HStack(alignment: .firstTextBaseline) {
                        Text("홈")
                            .font(Font.H1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 0))
                        Spacer()
                        Image("ico_profile")
                            .padding(EdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 21))
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 60,
                            alignment: .topLeading)
                }

                SearchBar(keyword: self.$output.keyword, isEditing: self.$output.isEditing, labels: self.$output.selectedLabels)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                if self.output.isEditing {
                    buildSearchView(keyword: self.output.keyword)
                } else {
                    buildSection(title: "최근 순 사진", images: output.recentlyImages, isRecently: true)
                    buildSection(title: "즐겨찾는 스크린샷", images: output.bookmarkImages, isRecently: false)
                }
            }
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }

    @ViewBuilder
    func buildSection(title: String, images: [ImageWrapper], isRecently: Bool) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)
            Spacer()
            NavigationLink(destination: HomeDeatilView(images: images.map { $0.image })) {
                Image("icon_arrow")
            }
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(images.indices, id: \.self) { i in
                    if isRecently {
                        let screenShot = $output.recentlyImages[i]
                        CScreenShotView(screenshot: screenShot, nextView: ScreenShotDetailView(screenShot: screenShot.image), width: 90, height: 195)
                    } else {
                        let screenShot = $output.bookmarkImages[i]
                        CScreenShotView(screenshot: screenShot, nextView: ScreenShotDetailView(screenShot: screenShot.image), width: 90, height: 195)
                    }
                }
            }.padding(.leading, 16).padding(.trailing, 16)
        }
    }

    @ViewBuilder
    func buildSearchView(keyword: String) -> some View {
        if keyword.isEmpty {
            VStack(alignment: .leading) {
                Text("최근 검색한 라벨")
                    .font(Font.B2_MEDIUM)
                    .foregroundColor(Color.PRIMARY_2)

                FlexibleView(data: output.labels, spacing: 10, alignment: HorizontalAlignment.leading) { label in
                    Text(label.name)
                        .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                        .font(Font.B1_REGULAR)
                        .foregroundColor(label.color.text)
                        .background(label.color.deactive)
                        .cornerRadius(3)
                        .onTapGesture {
                            if !output.selectedLabels.contains(label) {
                                output.selectedLabels.append(label)
                            } else {
                                if let index = self.output.selectedLabels.firstIndex(of: label) {
                                    self.output.selectedLabels.remove(at: index)
                                }
                            }
                        }
                }

                HStack {
                    Text("내 라벨")
                        .font(Font.B2_MEDIUM)
                        .foregroundColor(Color.PRIMARY_2)

                    Text("\(output.labels.count)")
                        .font(Font.B2_MEDIUM)
                        .foregroundColor(Color(hex: "257CCC"))
                        .padding(.leading, 4)
                }.padding(.top, 40)
                FlexibleView(data: output.labels, spacing: 10, alignment: HorizontalAlignment.leading) { label in
                    Text(label.name)
                        .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                        .font(Font.B1_REGULAR)
                        .foregroundColor(label.color.text)
                        .background(label.color.deactive)
                        .cornerRadius(3)
                        .onTapGesture {
                            if !output.selectedLabels.contains(label) {
                                output.selectedLabels.append(label)
                            } else {
                                if let index = self.output.selectedLabels.firstIndex(of: label) {
                                    self.output.selectedLabels.remove(at: index)
                                }
                            }
                        }
                }
            }.padding(20)
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text("검색결과")
                        .font(Font.B2_MEDIUM)
                        .foregroundColor(Color.PRIMARY_2)

                    Text("\(output.labels.filter { label in label.name.contains(keyword) }.count)")
                        .font(Font.B2_MEDIUM)
                        .foregroundColor(Color(hex: "257CCC"))
                        .padding(.leading, 4)
                }.padding(.top, 40)
                FlexibleView(data: output.labels.filter { label in label.name.contains(keyword) }, spacing: 10, alignment: HorizontalAlignment.leading) { label in
                    Text(label.name)
                        .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                        .font(Font.B1_REGULAR)
                        .foregroundColor(label.color.text)
                        .background(label.color.deactive)
                        .cornerRadius(3)
                        .onTapGesture {
                            if !output.selectedLabels.contains(label) {
                                output.selectedLabels.append(label)
                            } else {
                                if let index = self.output.selectedLabels.firstIndex(of: label) {
                                    self.output.selectedLabels.remove(at: index)
                                }
                            }
                        }
                }
            }.padding(20)
        }
    }

    class Output: ObservableObject {
        @Published var recentlyImages: [ImageWrapper] = []
        @Published var bookmarkImages: [ImageWrapper] = []
        @Published var isEditing: Bool = false
        @Published var keyword: String = ""
        @Published var labels: [LabelEntity] = [
            LabelEntity(id: "1", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()),
            LabelEntity(id: "2", name: "안녕1", color: ColorSet.BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "3", name: "안녕2", color: ColorSet.GREEN(), images: [], createdAt: Date()),
            LabelEntity(id: "4", name: "안녕3", color: ColorSet.GRAY(), images: [], createdAt: Date()),
            LabelEntity(id: "5", name: "간녕", color: ColorSet.CONBALT_BLUE(), images: [], createdAt: Date()),
            LabelEntity(id: "6", name: "간녕1", color: ColorSet.YELLOW(), images: [], createdAt: Date()),
            LabelEntity(id: "7", name: "간녕2", color: ColorSet.ORANGE(), images: [], createdAt: Date()),
            LabelEntity(id: "8", name: "간녕3", color: ColorSet.GRAY(), images: [], createdAt: Date())
        ]

        @Published var selectedLabels: [LabelEntity] = []

        func setImages(recentlyImages: [ImageEntity], bookmarkImages: [ImageEntity]) {
            self.recentlyImages = recentlyImages.map { ImageWrapper(imageEntity: $0, status: .IDLE) }
            self.bookmarkImages = bookmarkImages.map { ImageWrapper(imageEntity: $0, status: .IDLE) }
        }
    }
}
