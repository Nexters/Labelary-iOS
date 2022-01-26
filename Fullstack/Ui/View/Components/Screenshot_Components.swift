//
//  ScreenShot_Components.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/15.
//

import Foundation
import SwiftUI

// 즐겨찾기 목록 데이타
struct Screenshot: Identifiable {
    let id: Int
    let imageName: String // uuid ?? 앨범에서 꺼내올때
    var status = Status.IDLE

    enum Status {
        case IDLE
        case EDITING
        case SELECTING
    }
}

// 03.Label

struct AlbumThumbnailView: View {
    @ObservedObject var imageViewModel: ImageViewModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ThumbnailImageView(viewModel: imageViewModel)
            .cornerRadius(2)
            .frame(width: self.width, height: self.height)
    }
}

// EditAlbumView 에서 LazyVGridView의 Cell들
struct EditingScreenShotView: View {
    @ObservedObject var imageViewModel: ImageViewModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ImageView(viewModel: imageViewModel).frame(width: self.width, height: self.height)
    }
}

struct AlbumScreenShotView<NEXT_VIEW: View>: View {
    @ObservedObject var imageViewModel: ImageViewModel
    let width: CGFloat
    let height: CGFloat
    let nextView: NEXT_VIEW

    @State var isPresent: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: nextView) {
                ImageView(viewModel: imageViewModel)
                    .cornerRadius(2)
                    .frame(width: self.width, height: self.height)
            }

            switch imageViewModel.status {
            case .IDLE:
                Group {}
            case .EDITING:
                Image("btn_check")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        imageViewModel.status = .SELECTING
                    }
            case .SELECTING:
                Image("btn_check_selective")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        imageViewModel.status = .EDITING
                    }
            }

            Image("ico_heart_small")
                .padding(.leading, 8)
                .padding(.bottom, 8)

            Image("ico_label_small")
                .padding(.leading, 30)
                .padding(.bottom, 8)
        }
    }
}

// 02. Search

struct CScreenShotView<NEXT_VIEW: View>: View {
    @ObservedObject var imageViewModel: ImageViewModel
    let nextView: NEXT_VIEW
    let width: CGFloat
    let height: CGFloat
    @State var isLabeled = false
    @State var isPresent: Bool = false
    let viewModel = ViewModel()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: nextView, isActive: $isPresent) {
                ImageView(viewModel: imageViewModel)
                    .cornerRadius(2)
                    .frame(width: self.width, height: self.height)
            }

            switch imageViewModel.status {
            case .IDLE:
                Group {}
            case .EDITING:
                Image("btn_check")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        imageViewModel.status = .SELECTING
                    }
            case .SELECTING:
                Image("btn_check_selective")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        imageViewModel.status = .EDITING
                    }
            }

            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.9)]), startPoint: .center, endPoint: .bottom)
                .cornerRadius(2)
                .frame(width: self.width, height: self.height)

            Image("ico_heart_small")
                .padding(.leading, 8)
                .padding(.bottom, 8)
                .opacity(imageViewModel.image.isBookmark ? 1 : 0)

            Image("ico_label_small")
                .padding(.leading, 30)
                .padding(.bottom, 8)
                .opacity(isLabeled ? 1 : 0)

        }.onTapGesture {
            isPresent = true
        }
        .onAppear(perform: {
            if viewModel.countLabels(image: imageViewModel.image ) > 0 {
                isLabeled = true
            } else {
                isLabeled = false
            }
            
        
        })
    }

    class ViewModel: ObservableObject {
        // like 되었는가?
        let cancelBag = CancelBag()
        // label이 1개 이상 있는가 /?
        let searchLabelByImage = SearchLabelByImage(labelImageRepository: LabelImageRepositoryImpl(cachedDataSource: CachedData()))

        func countLabels(image: ImageEntity) -> Int {
            var labels: [LabelEntity] = []
            searchLabelByImage.get(param: image).sink(receiveCompletion: { _ in }, receiveValue: {
                data in
                labels.append(contentsOf: data.first?.labels ?? [])
            }).store(in: cancelBag)
            return labels.count
        }
        
    }
}
