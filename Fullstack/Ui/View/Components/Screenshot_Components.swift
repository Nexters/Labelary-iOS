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
    var id: Int
    let imageName: String // uuid ?? 앨범에서 꺼내올때
}

struct CScreenShotView: View {
    let screenshot: Screenshot
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("\(screenshot.imageName)")
                .resizable()
                .cornerRadius(2)
                .frame(width: 90, height: 195)
                .padding(.leading, 2)
                .padding(.trailing, 2)

            Image("ico_heart_small")
                .padding(.leading, 8)
                .padding(.bottom, 8)

            Image("ico_label_small")
                .padding(.leading, 30)
                .padding(.bottom, 8)
        }
    }
}
