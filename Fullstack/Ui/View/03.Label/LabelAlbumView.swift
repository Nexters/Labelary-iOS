//
//  LabelAlbumView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/19.
//

import SwiftUI

struct LabelAlbumView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstOption = true
    @State private var secondOption = false
    @State private var thirdOption = false

    let data = (1 ... 10).map { "NUMNER \($0)" }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        firstOption = true
                        secondOption = false
                        thirdOption = false
                        // 최신순으로 정렬
                    }) {
                        LabelBadge(name: "최신순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(firstOption ? 1 : 0), textColor: firstOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                            .font(Font.B2_MEDIUM)
                            .padding(.bottom, 8)
                    }.offset(x: 20)

                    Button(action: {
                        firstOption = false
                        secondOption = true
                        thirdOption = false
                        // 오래본순으로 정렬
                    }) {
                        LabelBadge(name: "오래본순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(secondOption ? 1 : 0), textColor: secondOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                            .font(Font.B2_MEDIUM)
                            .padding(.bottom, 8)
                    }.offset(x: 20)

                    Button(action: {
                        firstOption = false
                        secondOption = false
                        thirdOption = true
                        // 자주 본 순으로 정렬
                    }) {
                        LabelBadge(name: "자주본순", color: giveLabelBackgroundColor(color: passingLabelEntity.selectedLabel!.color).opacity(thirdOption ? 1 : 0), textColor: thirdOption ? giveTextForegroundColor(color: passingLabelEntity.selectedLabel!.color) : Color.PRIMARY_2)
                            .font(Font.B2_MEDIUM)
                            .padding(.bottom, 8)
                    }.offset(x: 20)
                    Spacer()
                }
                Spacer()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 25) {
                        Button(action: {}) {
                            Image("SS_large_state_\(colorToString(color: passingLabelEntity.selectedLabel!.color))")
                                .resizable()
                                .frame(width: 102, height: 221)
                        }

                        // 라벨에 해당하는 스크린샷 이미지 데이터 
//                        ForEach(data, id: \.self) { _ in
//                            Button(action: {}) {
//                                Image("SS_large_state_\(colorToString(color: passingLabelEntity.selectedLabel!.color))")
//                                    .resizable()
//                                    .frame(width: 102, height: 221)
//                            }
//                        }
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("navigation_back_btn")
                    }
                    Text("\(passingLabelEntity.selectedLabel!.name)").font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                },
                trailing:
                Button(action: {}) {
                    Text("선택").font(Font.B1_BOLD)
                        .foregroundColor(giveActiveColor(color: passingLabelEntity.selectedLabel!.color))
                })
        }.background(Color.DEPTH_4_BG.edgesIgnoringSafeArea(.all))
    }

    class viewModel: ObservableObject {}
}
