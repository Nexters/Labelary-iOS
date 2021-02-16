//
//  SearchView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchView: View {
    let screenshots: [Screenshot] = [
        Screenshot(id: 0, imageName: "sc0"),
        Screenshot(id: 1, imageName: "sc1"),
        Screenshot(id: 2, imageName: "sc2"),
        Screenshot(id: 3, imageName: "sc3"),
        Screenshot(id: 4, imageName: "sc3"),
        Screenshot(id: 5, imageName: "sc3"),
        Screenshot(id: 6, imageName: "sc3"),
        Screenshot(id: 7, imageName: "sc3")
    ]

    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("홈")
                        .font(Font.H1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 0))
                    Spacer()
                    Image("ico_profile")
                        .padding(EdgeInsets(top: 23, leading: 0, bottom: 0, trailing: 21))
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: 60,
                        alignment: .topLeading)

                SearchBar(keyword: "")
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))

                buildSection(title: "최근 순 사진")
                buildSection(title: "즐겨찾는 스크린샷")
            }
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
    }

    @ViewBuilder
    func buildSection(title: String) -> some View {
        HStack {
            Text(title)
                .font(Font.B1_BOLD)
                .foregroundColor(Color.PRIMARY_1)

            Spacer()

            Image("icon_arrow")
        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 14))

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(screenshots, id: \.id) {
                    screenshot in CScreenShotView(screenshot: screenshot)
                }
            }.padding(.leading, 16).padding(.trailing, 16)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
