//
//  AlbumEmptyView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/26.
//

import SwiftUI

// 엘범에 스크린샷이 없을때 보여주는 화면

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
                Text("스크린샷이 없습니다.".localized())
                    .font(Font.H3_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .padding(14)
                VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                    Text("해당 라벨에 스크린샷을".localized())
                    Text("추가해보세요.".localized())
                }
                .font(Font.B1_REGULAR)
                .foregroundColor(Color.PRIMARY_2)

                Button(action: {
                    self.show = true
                }, label: {
                    ZStack {
                       
                        Button(action: {
                            self.show = true
                        }, label: {
                            Text("라벨 생성하기".localized())
                                .frame(minHeight: 54, maxHeight: 54, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                .font(Font.B1_BOLD)
                                .foregroundColor(Color.PRIMARY_1)
                                .background(Color.KEY_ACTIVE)
                                .cornerRadius(4.0)
                        })
                        
                        NavigationLink(
                            destination: EditAlbumView(), // 스크린샷 선택 화면으로 이동해야 한다 !!!!!! 중요중요
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

                        Text("\(passingLabelEntity.selectedLabel!.name)")
                            .font(Font.B1_BOLD)
                            .foregroundColor(Color.PRIMARY_1)
                    }
                )
        }
    }
}
