//
//  customToast.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/07/15.
//

import SwiftUI

struct customToast: View {
    @Binding var show: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Text("스크린샷에 라벨이 추가되었습니다. ")
                    .foregroundColor(Color.DEPTH_3)
                    .font(Font.B2_MEDIUM)

                Spacer(minLength: 78)
                Button(action: {
                    print("앱으로 이동하기")
                    
                }, label: {
                    Text("보기")
                }).foregroundColor(Color.KEY_ACTIVE)
                    .font(Font.B1_BOLD)
                Spacer()
            }
            .frame(width: 335, height: 48, alignment: .leading)
            .background(Color.white)
            .cornerRadius(4.0)
            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            .onTapGesture {
                withAnimation {
                    self.show = false
                }
            }.onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.show = false
                    }
                }
            })
        }
    }
}

struct Overlay<T: View>: ViewModifier {
    @Binding var show: Bool
    let overlayView: T

    func body(content: Content) -> some View {
        ZStack {
            content

            if show {
                overlayView
            }
        }
    }
}

extension View {
    func overlay<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(Overlay(show: show, overlayView: overlayView))
    }
}
