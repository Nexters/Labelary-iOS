//
//  AlbumListEmptyStateView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/19.
//

import SwiftUI

struct AlbumListEmptyStateView: View {
    @State private var show: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Image("ico_empty_album")
                .padding(40)
            Text("라벨이 없습니다.")
                .font(Font.H3_BOLD)
                .foregroundColor(Color.PRIMARY_1)
                .padding(14)
            VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                Text("라벨을 생성하여 스크린샷에")
                Text("라벨을 추가해보세요.")
            }
            .font(Font.B1_REGULAR)
            .foregroundColor(Color.PRIMARY_2)

            Button(action: {
                self.show = true
            }, label: {
                Image("create_label")
            }).offset(y: 60)
                .sheet(isPresented: self.$show, content: {
                    AlbumAddLabelView()
                })

            Spacer().frame(height: 269)
        }.background(Color.black)
    }
}
