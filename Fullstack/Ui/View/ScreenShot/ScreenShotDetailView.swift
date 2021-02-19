//
//  ScreenShotDetailView.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import Foundation
import SwiftUI

struct ScreenShotDetailView: View {
//    @Binding var imageEntity : ImageEntity
    @Environment(\.presentationMode) var presentationMode
    @Binding var screenShot: ImageEntity
    @State var isOnHover: Bool = true

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                ImageView(img: screenShot)
                    .aspectRatio(contentMode: .fit)
            }
            VStack(spacing: 0) {
                if isOnHover {
                    HStack {
                        Image("ico_back")
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                        Text("2019년 1월 24일")
                            .font(Font.B1_MEDIUM)
                            .foregroundColor(Color.PRIMARY_1)
                        Spacer()
                    }.padding(EdgeInsets(top: 68, leading: 20, bottom: 16, trailing: 20))
                        .background(Color(hex: "B3000000"))
                        .edgesIgnoringSafeArea(.top)
                }

                Spacer()

                if isOnHover {
                    HStack {
                        if screenShot.labels.isEmpty {
                            Text("스크린샷에 추가된 라벨이 없습니다.")
                                .font(Font.B1_MEDIUM)
                                .foregroundColor(Color.PRIMARY_3)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(screenShot.labels.indices, id: \.self) { i in
                                        let label = screenShot.labels[i]
                                        Text(label.name)
                                            .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                            .font(Font.B1_REGULAR)
                                            .foregroundColor(label.color.text)
                                            .background(label.color.deactive)
                                            .cornerRadius(3)
                                    }
                                }
                            }
                        }

                        Spacer()
                        Text("추가")
                            .font(Font.B2_MEDIUM)
                            .foregroundColor(Color.KEY_ACTIVE)
                            .padding(.leading, 6)
                    }.padding(EdgeInsets(top: 22, leading: 20, bottom: 22, trailing: 20))
                        .background(Color(hex: "B3000000"))
                    ZStack {}.frame(width: .infinity, height: 0.5).background(Color.PRIMARY_2)
                    HStack {
                        Image("ico_delete_active")
                        Spacer()
                        Image("ico_heart")
                        Spacer()
                        Image("ico_share")
                    }.padding(EdgeInsets(top: 22, leading: 34, bottom: 56, trailing: 34))
                        .background(Color(hex: "B3000000"))
                        .edgesIgnoringSafeArea(.bottom)
                }
            }.edgesIgnoringSafeArea([.top, .bottom])

        }.onTapGesture {
            self.isOnHover = !isOnHover
        }.navigationBarHidden(true)
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
