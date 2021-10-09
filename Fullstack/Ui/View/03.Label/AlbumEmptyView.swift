//
//  AlbumEmptyView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/26.
//

import SwiftUI

struct AlbumEmptyView: View {
    @State private var show = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("ico_empty_screenshot")
                    .padding(40)
                Text("스크린샷이 없습니다.")
                    .font(Font.H3_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .padding(14)
                VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                    Text("해당 라벨에 스크린샷을")
                    Text("추가해보세요.")
                }
                .font(Font.B1_REGULAR)
                .foregroundColor(Color.PRIMARY_2)

                Button(action: {
                    self.show = true
                }, label: {
                    ZStack {
                        Image("add_screenshot_btn")
                        NavigationLink(
                            destination: AddNewLabelView(), // 스크린샷 선택 화면으로 이동해야 한다 !!!!!! 중요중요
                            isActive: $show
                        ) {}.isDetailLink(false)
                    }
                }).offset(y: 60)

                Spacer().frame(height: 269)
            }.navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("navigation_back_btn")
                        })

                        Text("라벨이름어쩌고")
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                    }
                )
        }
    }
}
