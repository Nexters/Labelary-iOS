//
//  OnboardingView.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import Foundation
import Lottie
import SwiftUI

struct OnboardingView: View {
    let pages: [PageViewData] = [
        PageViewData(source: "splash_1", title: "스크린샷에\n라벨을 추가해보세요.", description: "라벨별로 스크린샷을 볼 수 있어요.", buttonName: "다음"),
        PageViewData(source: "splash_2", title: "앱 실행 없이 빠른\n라벨 추가가 가능해요!", description: "스크린샷 공유 팝업에서 실행하세요.", buttonName: "다음"),
        PageViewData(source: "splash_3", title: "어딨더라?\n찾지 말고 검색하세요!", description: "라벨을 통해 쉽고 빠르게 스크린샷을 찾으세요.", buttonName: "완료")
    ]
    @State private var index: Int = 0
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            SwiperView(pages: pages, index: $index, onFinished: onFinished)
            HStack(alignment: .top) {
                ZStack {}.frame(width: 6, height: 6, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .background(index == 0 ? Color.KEY_ACTIVE : Color.PRIMARY_3)
                ZStack {}.frame(width: 6, height: 6, alignment: .center)
                    .background(index == 1 ? Color.KEY_ACTIVE : Color.PRIMARY_3)
                ZStack {}.frame(width: 6, height: 6, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .background(index == 2 ? Color.KEY_ACTIVE : Color.PRIMARY_3)
            }.offset(x: -130, y: 80.0)
        }
    }
}

struct SwiperView: View {
    let pages: [PageViewData]

    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    let onFinished: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { viewData in
                        PageView(viewData: viewData, action: {
                            if index < pages.count - 1 {
                                index += 1
                            } else {
                                onFinished()
                            }
                        }).frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }.content
                .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
                .frame(width: geometry.size.width, alignment: .leading)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.isUserSwiping = true
                            self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
                        }
                        .onEnded { value in
                            if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < self.pages.count - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                            withAnimation {
                                self.isUserSwiping = false
                            }
                            print("offset \(offset)")
                        }
                )
        }
    }
}

struct PageViewData: Identifiable {
    let id: String = UUID().uuidString
    let source: String
    let title: String
    let description: String
    let buttonName: String
}

struct PageView: View {
    let viewData: PageViewData
    let action: () -> Void

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                LottieView(filename: viewData.source)
                    .frame(minWidth: 375, maxWidth: 375, minHeight: 472, maxHeight: 472, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                Text(viewData.title)
                    .font(Font.H2_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .padding(.leading, 40)
                Text(viewData.description)
                    .font(Font.B2_REGULAR)
                    .foregroundColor(Color.PRIMARY_2)
                    .padding(.leading, 40)
                    .padding(.top, 16)

                Button(action: {
                    self.action()
                }, label: {
                    Text(viewData.buttonName)
                        .frame(minWidth: 295, maxWidth: 295, minHeight: 54, maxHeight: 54, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .background(Color.KEY_ACTIVE)
                        .cornerRadius(4.0)
                })
                    .padding(.top, 52)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                Spacer()
            }
        }
    }
}
