//
//  SettingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/12/12.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.top)
            Color.DEPTH_5.edgesIgnoringSafeArea(.bottom)
            VStack {
                Button(action: {}, label: {
                    Text("앱스토어에 리뷰쓰기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {}, label: {
                    Text("친구에게 추천하기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.bottom, 20)
                    .padding(.top, -9)

                Button(action: {}, label: {
                    Text("이용방법 보기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)

                Button(action: {}, label: {
                    Text("빠른 라벨링 설정하기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1)
                        .padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.top, -9)
                Button(action: {}, label: {
                    Text("피드백 보내기")
                        .font(Font.B1_MEDIUM).foregroundColor(Color.PRIMARY_1).padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 20)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                    .padding(.bottom, 20)
                    .padding(.top, -9)

                Button(action: {
                    // label 초기화
                }, label: {
                    VStack(alignment: .leading) {
                        Text("라벨 초기화하기")
                            .foregroundColor(Color.LABEL_RED_ACTIVE)
                            .font(Font.B1_MEDIUM)
                            .padding(.bottom, 1)
                        Text("라벨 내역이 초기화되며, 스크린샷은 삭제되지 않습니다.")
                            .foregroundColor(Color.PRIMARY_2)
                            .font(Font.B2_REGULAR)
                    }.padding(.leading, 20)
                    Spacer()
                    Image("ico_next")
                        .padding(.trailing, 10)
                }).frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                    .background(Color.DEPTH_4_BG)
                Spacer()
            }
            .padding(.top, -35)
            .navigationTitle("")
            .background(Color.DEPTH_5)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:

                HStack {
                    Button(action:  {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("navigation_back_btn")
                    })
                    .padding(.leading, -12)
                }
            )
        }
    }
    
    class ViewModel: ObservableObject {
        
    }
}
