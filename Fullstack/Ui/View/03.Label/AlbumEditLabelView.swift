//
//  AlbumEditLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/10/15.
//

import SwiftUI

// 스크린샷 라벨 변경

struct AlbumEditLabelView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var isSelected: Bool = false

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
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
            }
        }
    }

    class ViewModel: ObservableObject {
        let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
        let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))
        
        @Published var labels: [LabelEntity] = []
        @Published var selectedLabel: [LabelEntity] = []
        
        let cancelBag = CancelBag()

        init() {
            loadLabelingSelectData.get()
                .sink(receiveCompletion: { _ in }, receiveValue: { [self] data in
                    labels = data
                }).store(in: cancelBag)
        }
    }
}
