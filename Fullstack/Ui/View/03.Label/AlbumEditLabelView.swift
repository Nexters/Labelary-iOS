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
    @State var selectedLabel: LabelEntity?

    var body: some View {
        ZStack(alignment: .top) {
            Color.DEPTH_3.edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                Text("현재 라벨").font(Font.B2_MEDIUM).foregroundColor(Color.PRIMARY_2)

                Text("\(passingLabelEntity.selectedLabel!.name)").font(Font.H3_MEDIUM)
                    .offset(y: 9.0)

                Text("변경할 라벨").font(Font.B2_MEDIUM).foregroundColor(Color.PRIMARY_2)
                    .padding(.top, 40)

                if !isSelected {
                    Text("새 라벨을 선택해 주세요.")
                        .font(Font.H1_MEDIUM).foregroundColor(Color.PRIMARY_4)
                        .offset(y: 9.0)
                } else {
                    Text("\(selectedLabel!.name)")
                        .font(Font.H1_MEDIUM)
                        .offset(y: 9.0)
                }

                HStack {
                    Text("내 라벨").foregroundColor(Color.PRIMARY_2)
                    Text("\(viewModel.labels.count)").foregroundColor(Color.KEY_ACTIVE)
                }.font(Font.B2_MEDIUM)
                    .padding(.top, 80)

                // flexible view -> selected 되면 버튼 x 뜨게 한다
                FlexibleView(data: viewModel.labels, spacing: 8, alignment: HorizontalAlignment.leading) {
                    label in Button(action: {
                        selectedLabel = label
                        isSelected = true

                    }) {
                        HStack {
                            Text(verbatim: label.name)
                            if selectedLabel == label { Image("btn_icon_cancel").onTapGesture {
                                selectedLabel = nil
                                isSelected = false
                            } }
                        }.padding(8)
                            .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                            .background(giveLabelBackgroundColor(color: label.color))
                            .foregroundColor(giveTextForegroundColor(color: label.color))
                    }
                }
            }.padding(20)
            Spacer()
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) { Image("ico_cancel")
                    }
                    Spacer(minLength: 100)
                    Text("스크린샷 라벨 변경").foregroundColor(Color.PRIMARY_1).font(Font.B1_BOLD)
                },

                trailing: HStack {
                    Button(action: {
                        viewModel.selectedLabel = selectedLabel

                        viewModel.changeLabelOnImage.get(param: ChangeFromLabelToLabel.RequestData(images: passingImageEntity.selectedImages, fromLabel: passingLabelEntity.selectedLabel!, toLabel: viewModel.selectedLabel!)).sink(receiveCompletion: { _ in }, receiveValue: { _ in
                        }).store(in: viewModel.cancelBag)
                        presentationMode.wrappedValue.dismiss()
                        passingImageEntity.selectedImages.removeAll()
                    }) {
                        Text("완료").font(Font.B1_MEDIUM).foregroundColor(Color.KEY_ACTIVE)
                    }.disabled(!isSelected)
                })
    }

    class ViewModel: ObservableObject {
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        let changeLabelOnImage = ChangeFromLabelToLabel(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        @Published var labels: [LabelEntity] = []
        @Published var selectedLabel: LabelEntity?

        let cancelBag = CancelBag()

        init() {
            loadLabelingSelectData.get()
                .sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
                    labels = data
                }).store(in: cancelBag)
        }
    }
}
