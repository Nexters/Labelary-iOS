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

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: nextView) {
                ImageView(viewModel: imageViewModel)
                    .cornerRadius(2)
                    .frame(width: self.width, height: self.height)
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

    @State var isPresent: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: nextView) {
                ImageView(viewModel: imageViewModel)
                    .cornerRadius(2)
                    .frame(width: self.width, height: self.height)
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
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
