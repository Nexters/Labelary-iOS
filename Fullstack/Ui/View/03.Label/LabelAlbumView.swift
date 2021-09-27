//
//  LabelAlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import SwiftUI

struct LabelAlbumView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG
            VStack {
                HStack {
                    Button(action: {}) {
                        Text("최신순")
                    }
                    Button(action: {}) {
                        Text("오래본순")
                    }
                    Button(action: {}) {
                        Text("자주본순")
                    }

                    Spacer()
                }

            }.navigationBarBackButtonHidden(true)
            HStack {
                // 뒤로가기버튼
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("navigation_back_btn")
                }.offset(x: 20)
            }
        }
    }

    class viewModel: ObservableObject {}
}
