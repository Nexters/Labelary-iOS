//
//  AlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct LabelView: View {
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

    @State var labels: [LabelEntity] = [LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date()), LabelEntity(id: "", name: "안녕", color: ColorSet.RED(), images: [], createdAt: Date())]

    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text("라벨")
                        .font(Font.H1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                    Spacer()
                    Image("ico_add_album")
                        .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 16))
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 60,
                        maxHeight: 60,
                        alignment: .topLeading)
                    .padding(.bottom, 20)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]){
                        ForEach(labels.indices,id : \.self){ i in
                            let label = labels[i]
                            buildLabelView(label: label)
                        }
                    }.padding(EdgeInsets(top: 20, leading: 13, bottom: 20, trailing: 13))
                }
            }
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }

    @ViewBuilder
    func buildLabelView(label: LabelEntity) -> some View {
        VStack(alignment: .leading) {
            if label.images.isEmpty {
                ZStack {
                    Image("ico_more")
                        .padding(.leading, 115)
                        .padding(.bottom,115)

                    Image("ico_empty_screenshot")
                       
                }.frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160,alignment: .center).background(Color.DEPTH_3)
            } else {
//                Image(label.images.first!!.id)
//                    .frame(minWidth: 160, maxWidth: 160, minHeight: 160, maxHeight: 160)
            }

            Text(label.name).font(Font.B2_MEDIUM).padding(.bottom, 8).foregroundColor(Color.PRIMARY_1)

            Text("\(label.images.count)").font(Font.B3_MEDIUM).padding(.bottom, 15).foregroundColor(Color.PRIMARY_2)
        }.padding(.leading, 7).padding(.trailing, 7).padding(.bottom, 8)
    }
}
