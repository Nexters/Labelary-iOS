//
//  DefaultView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/06/24.
//

import SwiftUI

// 라벨이 없을때 화면
struct DefaultView: View {
    @State private var show: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Image("ico_empty_album")
                .padding(40)
            Text("라벨이 없습니다.".localized())
                .font(Font.H3_BOLD)
                .foregroundColor(Color.PRIMARY_1)
                .padding(14)
            VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                Text("라벨을 생성하여 스크린샷에".localized())
                Text("라벨을 추가해보세요.".localized())
            }
            .font(Font.B1_REGULAR)
            .foregroundColor(Color.PRIMARY_2)

            Button(action: {
                self.show = true
            }, label: {
                Text("라벨 생성하기".localized())
                    .frame(minWidth: 160, maxWidth: 160, minHeight: 48, maxHeight: 48, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .font(Font.B1_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .background(Color.KEY_ACTIVE)
                    .cornerRadius(4.0)
                NavigationLink(
                    destination: AddNewLabelView(),
                    isActive: $show
                ) {}.isDetailLink(false)
            }).offset(y: 60)

            Spacer().frame(height: 269)
        }.background(Color.black)
    }
}
