//
//  LabelDetailView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/18.
//
import RealmSwift
import SwiftUI
import UIKit

struct LabelDetailView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""
    @State var selectedIndex: Int? = -1
    @State var isSelected: Bool = false
    @State private var selectedColor: String = ""
    @State private var color: ColorSet = .RED()

    let realm: Realm = try! Realm()
    let createLabel = CreateLabel(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    let cancelbag = CancelBag()
    var body: some View {
        ZStack {
            Color.DEPTH_5.ignoresSafeArea(edges: .all)
            VStack {
                VStack(alignment: .leading) {
                    Text("라벨명").font(.custom("Apple SD Gothic Neo", size: 12))
                        .foregroundColor(Color.PRIMARY_2)
                        .frame(width: 37, height: 20, alignment: .leading)
                        .padding(7)

                    FirstResponderTextField(text: $text, placeholder: "라벨명을 입력해주세요.")
                        .frame(width: 350, height: 40, alignment: .trailing)
                        .foregroundColor(Color.PRIMARY_4)
                        .padding(7)

                    Text("라벨 컬러 선택").font(.custom("Apple SD Gothic Neo", size: 12))
                        .foregroundColor(Color.PRIMARY_2)
                        .frame(width: 81, height: 20, alignment: .leading)
                        .padding(7)
                }
                HStack(alignment: .center) {
                    VStack {
                        ForEach(0 ..< labelButtons.count / 2) {
                            button in

                            Button(action: {
                                self.selectedIndex = button
                                self.isSelected = true
                                self.selectedColor = self.labelButtons[button]
                                color = setLabelColor(_color: selectedColor)
                            }) {
                                if selectedIndex == button {
                                    Image("Label_middle_Selected_\(self.labelButtons[button])")

                                } else {
                                    Image("Label_middle_dark_\(self.labelButtons[button])")
                                }
                            }
                            .padding([.top, .leading], 10)
                        }
                    }

                    VStack {
                        ForEach(5 ..< labelButtons.count) {
                            button in

                            Button(action: {
                                self.selectedIndex = button
                                self.isSelected = true
                                self.selectedColor = self.labelButtons[button]
                                color = setLabelColor(_color: selectedColor)

                            }) {
                                if selectedIndex == button {
                                    Image("Label_middle_Selected_\(self.labelButtons[button])")
                                } else {
                                    Image("Label_middle_dark_\(self.labelButtons[button])")
                                }
                            }
                            .padding([.top, .leading], 10)
                        }
                    }
                }
                Spacer()

                Button(action: {
                    // create label

                }) {
                    ZStack {
                        Image(self.isSelected ? "Label_add_complete_active" : "Label_add_complete_default")
                            .frame(width: 335, height: 54, alignment: .center).padding([.leading, .trailing], 18)
                            .onTapGesture {
                                if self.isSelected {
                                    createLabel.get(param: CreateLabel.RequestData(text: text, color: color))
                                        .sink(receiveCompletion: { _ in
                                            print("complete create label")

                                        }, receiveValue: { _ in
                                        }).store(in: cancelbag)

                                    onClickedBackBtn()
                                }
                            }
                    }
                }
            }
            Spacer()

                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack {
                        Button(action: {
                            onClickedBackBtn()
                        }) {
                            Image("navigation_back_btn")
                        }
                        Spacer()
                        Text("라벨 생성")
                            .foregroundColor(Color.PRIMARY_1)
                        Spacer()
                    })
        }
    }

    func onClickedBackBtn() {
        self.presentationMode.wrappedValue.dismiss()
    }

    func setLabelColor(_color: String) -> ColorSet {
        switch _color {
        case "Red":
            return .RED()
        case "Orange":
            return .ORANGE()
        case "Yellow":
            return .YELLOW()
        case "Green":
            return .GREEN()
        case "Peacock_Green":
            return .PEACOCK_GREEN()
        case "Blue":
            return .BLUE()
        case "Cobalt_Blue":
            return .CONBALT_BLUE()
        case "Pink":
            return .PINK()
        case "Gray":
            return .GRAY()
        default:
            return .RED()
        }
    }

    class Output: ObservableObject {
        @Published var newLabel: LabelEntity?
        init(newLabel: LabelEntity) {
            self.newLabel = newLabel 
        }
    }
}