//
// FastLabelingView.swift
// Fullstack
//
// Created by 우민지 on 2021/12/13.
//
import Foundation
import SwiftUI
// 빠른 라벨링 설정하기
struct FastLabelingView: View {
    let pages: [FastLabelingPageViewData] = [
        FastLabelingPageViewData(description: "편집을 누른 후 제안에서\n레이블러리의 +를 눌러주세요", source: "labelingsetting_img_1", state: "indicator_1", buttonName: "다음"),
        FastLabelingPageViewData(description: "스크린샷을 할 때마다\n빠르게 라벨링 할 수 있어요.", source: "labelingsetting_img_2", state: "indicator_2", buttonName: "설정하기")
    ]
    @State private var index: Int = 0
    @Environment(\.presentationMode) var presentationMode

    let onFinished: () -> Void
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                FastLabelingSwiperView(pages: pages, index: $index, onFinished: onFinished)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) { Image("ico_back") }
                .padding(.trailing, 100)
                Text("빠른 라벨링 설정하기 ")
                    .font(Font.B1_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
            })
    }
}

struct FastLabelingSwiperView: View {
    let pages: [FastLabelingPageViewData]

    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    let onFinished: () -> Void
    let shareItem = UIImage(named: "AppIcon")!

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { viewData in
                        FastLabelingPageView(viewData: viewData, action: {
                            if index < pages.count - 1 {
                                index += 1
                            } else {
                                let activityVC = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
                                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
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

struct FastLabelingPageViewData: Identifiable {
    let id: String = UUID().uuidString
    let description: String
    let source: String
    let state: String
    let buttonName: String
}

struct FastLabelingPageView: View {
    let viewData: FastLabelingPageViewData
    let action: () -> Void

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Spacer()
                    Image(viewData.source)
                        .frame(width: 196, height: 363, alignment: .center)
                    Spacer()
                }
                Image(viewData.state)
                    .padding(.top, 39)
                    .padding(.leading, 20)
                Text(viewData.description)
                    .font(Font.H2_BOLD)
                    .foregroundColor(Color.PRIMARY_1)
                    .padding(.leading, 40)

                Button(action: { self.action() },
                       label: {
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
