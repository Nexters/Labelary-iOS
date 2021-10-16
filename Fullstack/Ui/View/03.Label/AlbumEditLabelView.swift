//
//  AlbumEditLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/10/15.
//

import SwiftUI

// 스크린샷 라벨 변경

struct AlbumEditLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ViewModel()
    @State var isSelected: Bool = false

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("현재 라벨").font(Font.B2_MEDIUM).foregroundColor(Color.PRIMARY_2)
                Text("현재 라벨 이름 어쩌고").font(Font.H3_MEDIUM)

                Text("변경할 라벨").font(Font.B2_MEDIUM).foregroundColor(Color.PRIMARY_2)
                if !isSelected {
                    Text("새 라벨을 선택해 주세요.").font(Font.H1_MEDIUM).foregroundColor(Color.PRIMARY_4)
                } else {
                    Text("\(viewModel.selectedLabel[0].name)").font(Font.H1_MEDIUM)
                }

                HStack {
                    Text("내 라벨").foregroundColor(Color.PRIMARY_2)
                    Text("\(viewModel.labels.count)").foregroundColor(Color.KEY_ACTIVE)
                }.font(Font.B2_MEDIUM)
                // flexible view -> selected 되면 버튼 x 뜨게 한다
                FlexibleView(data: viewModel.labels, spacing: 8, alignment: HorizontalAlignment.leading) {
                    label in Button(action: {
                        viewModel.selectedLabel.append(label)
                    }) {
                        Text(verbatim: label.name)
                            .padding(8)
                            .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                            .background(giveLabelBackgroundColor(color: label.color))
                            .foregroundColor(giveTextForegroundColor(color: label.color))
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) { Image("ico_cancel")
                    }
                    Text("스크린샷 라벨 변경").foregroundColor(Color.PRIMARY_1).font(Font.B1_BOLD)
                },
                trailing: HStack {
                    Button(action: {
                        viewModel.requestLabeling.get(param: RequestLabeling.Param(labels: viewModel.selectedLabel, images: viewModel.selectedImages)).sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: viewModel.cancelBag)
                    }) {
                        Text("완료").font(Font.B1_MEDIUM).foregroundColor(Color.KEY_ACTIVE)
                    }
                })
    }

    class ViewModel: ObservableObject {
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

        @Published var labels: [LabelEntity] = []
        @Published var selectedLabel: [LabelEntity] = []
        @Published var selectedImages: [ImageEntity] = []

        let cancelBag = CancelBag()

        init() {
            loadLabelingSelectData.get()
                .sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
                    labels = data
                }).store(in: cancelBag)
        }
    }
}
