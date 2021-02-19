//
//  LabelViewFromOutside.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/15.
//

import SwiftUI

func giveLabelBackgroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 232/255, green: 194/255, blue: 93/255).opacity(0.15)
    case "Red":
        return Color(red: 199/255, green: 103/255, blue: 97/255).opacity(0.15)
    case "Violet":
        return Color(red: 160/255, green: 110/255, blue: 229/255).opacity(0.15)
    case "Blue":
        return Color(red: 76/255, green: 166/255, blue: 255/255).opacity(0.15)
    case "Green":
        return Color(red: 62/255, green: 168/255, blue: 122/255).opacity(0.15)
    case "Orange":
        return Color(red: 236/255, green: 145/255, blue: 71/255).opacity(0.15)
    case "Pink":
        return Color(red: 224/255, green: 137/255, blue: 181/255).opacity(0.15)
    case "Cobalt_Blue":
        return Color(red: 101/255, green: 101/255, blue: 229/255).opacity(0.15)
    case "Peacock_Green":
        return Color(red: 82/255, green: 204/255, blue: 204/255).opacity(0.15)
    case "Gray":
        return Color(red: 123/255, green: 131/255, blue: 153/255).opacity(0.15)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.15)
    }
}

func giveTextForegroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 255/255, green: 226/255, blue: 153/255)
    case "Red":
        return Color(red: 255/255, green: 167/255, blue: 153/255)
    case "Violet":
        return Color(red: 217/255, green: 194/255, blue: 255/255)
    case "Blue":
        return Color(red: 178/255, green: 217/255, blue: 255/255)
    case "Green":
        return Color(red: 177/255, green: 229/255, blue: 207/255)
    case "Orange":
        return Color(red: 255/255, green: 203/255, blue: 161/255)
    case "Pink":
        return Color(red: 255/255, green: 199/255, blue: 227/255)
    case "Cobalt_Blue":
        return Color(red: 191/255, green: 191/255, blue: 255/255)
    case "Peacock_Green":
        return Color(red: 161/255, green: 229/255, blue: 229/255)
    case "Gray":
        return Color(red: 204/255, green: 218/255, blue: 255/255)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255)
    }
}

// MARK: - Lable

struct Label: Hashable {
    var id = UUID()
    var label: String
    var color: String
}

// MARK: - list of label data

var labelEntities = [
    Label(label: "OOTD", color: "Cobalt_Blue"),
    Label(label: "컬러 팔레트", color: "Yellow"),
    Label(label: "UI 레퍼런스", color: "Red"),
    Label(label: "편집디자인", color: "Violet"),
    Label(label: "채팅", color: "Blue"),
    Label(label: "meme 모음", color: "Cobalt_Blue"),
    Label(label: "글귀", color: "Pink"),
    Label(label: "장소(공연, 전시 등)", color: "Orange"),
    Label(label: "영화", color: "Gray"),
    Label(label: "네일", color: "Green"),
    Label(label: "맛집", color: "Peacock_Green"),
    Label(label: "인테리어", color: "Cobalt_Blue")
]

struct LabelViewFromOutside: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var keyword: String = ""
    @State private var numberOfMyLables: Int = 0
    @State var selectedLabels: [Label] = []
    @State var showAddLabelView: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.DEPTH_3.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Spacer(minLength: 80)
                            Rectangle()
                                .frame(width: 60, height: 131)
                                .padding()
                            ShareSheetSearchBarView(text: $keyword)
                            if self.keyword.isEmpty {
                                HStack {
                                    Text("내 라벨")
                                    Text(" \(labelEntities.count)").foregroundColor(Color.KEY_ACTIVE)
                                }.padding([.leading, .top], 20)
                            } else {
                                if labelEntities.filter { $0.label.contains(keyword) }.count > 0 {
                                    HStack {
                                        Text("검색 결과")
                                        Text("\(labelEntities.filter { $0.label.contains(keyword) }.count)").foregroundColor(Color.KEY_ACTIVE)
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        Text("검색결과가 없습니다 ").offset(x: 10)
                                        Spacer(minLength: 10)
                                        HStack {
                                            Text("\(keyword)")
                                            Button("생성") {
                                                self.showAddLabelView = true
                                                NavigationLink(destination: ShareSheetAddNewLabel(), isActive: $showAddLabelView) {}
                                            }.foregroundColor(Color.KEY)
                                        }.padding(8)
                                        .background(Color.DEPTH_3)
                                        .cornerRadius(2)
                                        .border(Color.PRIMARY_4)
                                    }
                                }
                            }
                            FlexibleView(data: labelEntities.filter { keyword.isEmpty ? true : $0.label.contains(keyword) }, spacing: 8, alignment: HorizontalAlignment.leading) {
                                label in Button(action: {
                                    selectedLabels.append(label)
                                    print(label)
                                    print(selectedLabels.count)
                                }) {
                                    Text(verbatim: label.label)
                                        .padding(8)
                                        .background(giveLabelBackgroundColor(color: label.color))
                                        .foregroundColor(giveTextForegroundColor(color: label.color))
                                }
                            }.padding([.leading], 20)
                        }
                        Spacer(minLength: 20)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("선택한 라벨")
                                Text("\(selectedLabels.count)").foregroundColor(Color.KEY_ACTIVE)
                            }.padding([.leading, .top], 20)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(selectedLabels, id: \.self) { filter in
                                        Badge(name: filter.label, color: giveLabelBackgroundColor(color: filter.color), textColor: giveTextForegroundColor(color: filter.color), type: .removable {
                                            withAnimation {
                                                if let firstIndex = selectedLabels.firstIndex(of: filter) {
                                                    selectedLabels.remove(at: firstIndex)
                                                }
                                            }

                                        })
                                            .transition(.opacity)
                                    }
                                }
                            }.padding(20)

                        }.background(Color.DEPTH_4_BG)
                            .frame(width: UIScreen.main.bounds.width, height: 101)
                            .opacity(selectedLabels.count > 0 ? 1 : 0)
                    }
                }
            }.navigationBarItems(leading:
                HStack {
                    Button(action: {}, label: {
                        Image("navigation_back_btn")
                    })
                    Spacer(minLength: 20)
                    Text("스크린샷 라벨 추가")
                    Spacer(minLength: 20)
                    Button(action: {}, label: {
                        Text("완료")
                    })
                })
        }
    }
}

struct LabelViewFromOutside_Previews: PreviewProvider {
    static var previews: some View {
        LabelViewFromOutside()
    }
}
