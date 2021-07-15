//
//  DefaultView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/06/24.
//

import SwiftUI

// 라벨이 없을때 화면
struct DefaultView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 254)
            Image("ico_empty_album")
                .padding(40)
            Text("라벨이 없습니다.")
                .foregroundColor(Color.primary)
                .padding(14)
            Text("라벨을 생성하여 스크린샷에\n 라벨을 추가해보세요.")
                .foregroundColor(Color.secondary)
                .padding(60)

            Button(action: {
                // 라벨 생성하기로 이동 (+버튼)
            }) {
                Image("create_label")
            }
            Spacer()
        }.background(Color.black)
    }
}

