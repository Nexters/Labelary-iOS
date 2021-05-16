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

struct CScreenShotView<NEXT_VIEW: View>: View {
    @Binding var screenshot: ImageWrapper
    let nextView: NEXT_VIEW
    let width: CGFloat
    let height: CGFloat

    @State var isPresent: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: nextView) {
                ImageView(img : screenshot.image)                    
                    .cornerRadius(2)
                    .frame(width: self.width, height: self.height)
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
                    .blur(radius: 3.0)
            }

            switch screenshot.status {
            case .IDLE:
                Group {}
            case .EDITING:
                Image("btn_check")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        screenshot.status = .SELECTING
                    }
            case .SELECTING:
                Image("btn_check_selective")
                    .padding(.leading, 72)
                    .padding(.bottom, 191)
                    .onTapGesture {
                        screenshot.status = .EDITING
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
