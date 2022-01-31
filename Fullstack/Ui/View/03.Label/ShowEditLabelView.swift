import RealmSwift
import SwiftUI
import UIKit

// 라벨 수정하기
struct ShowEditLabelView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""

    @State var selectedIndex: Int? = -1
    @State var isSelected: Bool = false
    @State private var selectedColor: String = ""
    @State private var color: ColorSet = .RED()

    let realm: Realm = try! Realm()

    let updateLabel = UpdateLabel(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    let cancelbag = CancelBag()

    var body: some View {
        ZStack {
            Color.DEPTH_3.ignoresSafeArea(edges: .all)

            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            dismissModal()
                        }) {
                            Image("btn_cancel")
                        }
                        Spacer()
                    }.padding(.leading, 20)

                    HStack(alignment: .center) {
                        Text("라벨 수정".localized())
                            .foregroundColor(Color.PRIMARY_1)
                            .font(.custom("Apple SD Gothic Neo", size: 16))
                            .fontWeight(.bold)
                    }
                }.frame(height: 50)

                VStack(alignment: .leading) {
                    Text("라벨명".localized()).font(.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(Color.PRIMARY_2)
                        .frame(height: 20, alignment: .leading)
                        .padding(7)

                    TextField("라벨명을 입력해주세요.".localized(), text: $text)
                        .font(.custom("Apple SD Gothic Neo", size: 28))
                        .frame(width: 350, height: 40, alignment: .trailing)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(7)

                    Text("라벨 컬러 선택".localized()).font(.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(Color.PRIMARY_2)
                        .frame(height: 20, alignment: .leading)
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
//                        Image(self.isSelected ? "Label_add_complete_active" : "Label_add_complete_default")
//                            .frame(width: 335, height: 54, alignment: .center).padding([.leading, .trailing], 18)
//                            .onTapGesture {
//                                if self.isSelected {
//                                    passingLabelEntity.selectedLabel?.name = self.text
//                                    passingLabelEntity.selectedLabel?.color = self.color
//
//                                    updateLabel.get(param: passingLabelEntity.selectedLabel!).sink(receiveCompletion: { _ in
//                                        print("complete update label")
//                                    }, receiveValue: { _ in }).store(in: cancelbag)
//
//                                    dismissModal()
//                                }
//                            }

                        Button(action: {
                            if self.isSelected {
                                passingLabelEntity.selectedLabel?.name = self.text
                                passingLabelEntity.selectedLabel?.color = self.color
                                updateLabel.get(param: passingLabelEntity.selectedLabel!)
                                    .sink(receiveCompletion: { _ in
                                        print("complete create label")

                                    }, receiveValue: { _ in
                                    }).store(in: cancelbag)

                                dismissModal()
                            }
                        }, label: {
                            Text("라벨 수정 완료".localized())
                                .frame(minWidth: 376, maxWidth: 376, minHeight: 54, maxHeight: 54, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                .font(Font.B1_BOLD)
                                .foregroundColor(self.isSelected ? Color.PRIMARY_1 : Color.PRIMARY_3)
                                .background(self.isSelected ? Color.KEY_ACTIVE : Color.KEY_INACTIVE)
                                .cornerRadius(4.0)
                        })
                    }
                }
            }
            Spacer()

        }.onAppear(perform: {
            self.text = passingLabelEntity.selectedLabel?.name ?? ""
        })
    }

    func dismissModal() {
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
            self.newLabel = newLabel // imageData from the url
        }
    }
}
