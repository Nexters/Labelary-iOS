//
//  DefaultView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/06/24.
//

import SwiftUI

struct DefaultView: View {
    var body: some View {
        Image("ico_empty_album")
        Text("라벨이 없습니다.")
        Text("라벨을 생성하여 스크린샷에\n 라벨을 추가해보세요.")

        Button(action: {}) {
            Image("create_label")
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
