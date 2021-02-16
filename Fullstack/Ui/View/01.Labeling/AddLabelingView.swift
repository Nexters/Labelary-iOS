import Combine
import SwiftUI
import ToastUI

// MARK: - functions to give color for GUI

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

// MARK: - Label (for label entities list)

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

// MARK: - Each Customed Post-it Label View

struct LabelRowItemView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    var label: Label

    @State var isSelected: Bool = false
    @Binding var selectedLabels: [Label]

    var body: some View {
        Button(action: {
            self.isSelected.toggle()
            if isSelected {
                selectedLabels.append(label)
            } else {
                if let firstIndex = selectedLabels.firstIndex(of: label) {
                    selectedLabels.remove(at: firstIndex)
                }
            }

        }, label: {
            Text(label.label)
                .padding(40)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.horizontal)
                .background(isSelected ? Image("Label_large_Selected_\(label.color)") : Image("Label_large_default_\(label.color)"))
                .offset(x: isSelected ? -80 : -100)

        })
    }
}

// MARK: - Parent View

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var labels = labelEntities
    @State var filters: [Label] = []
    @State var showAddLabelingView = false
    @State var showSearchLabelView = false
    @State var isEdited = false
    @State var presentingToast: Bool = false

    // MARK: - NavigationLink Action funtions

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }

    func onClickedSearchBtn() {
        showSearchLabelView = true
    }

    func onClickedAddBtn() {
        showAddLabelingView = true
    }

    func onClickedConfirmBtn() {
        isEdited = true
    }

    var body: some View {
        VStack {
            // MARK: - List of Badge Views of selected labels

            VStack(alignment: .leading) {
                if filters.count > 0 {
                    HStack {
                        Text("선택한 라벨")
                        Text("\(filters.count)").foregroundColor(Color(red: 56/255, green: 124/255, blue: 255/255))

                    }.padding(.leading, 15)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            Badge(name: filter.label, color: giveLabelBackgroundColor(color: filter.color), textColor: giveTextForegroundColor(color: filter.color), type: .removable {
                                withAnimation {
                                    if let firstIndex = filters.firstIndex(of: filter) {
                                        filters.remove(at: firstIndex)
                                    }
                                }

                            })
                                .transition(.opacity)
                        }
                    }
                }.padding(15)
            }

            // MARK: - List of the Labels

            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(labels, id: \.self) { label in
                            LabelRowItemView(label: label,
                                             selectedLabels: $filters)
                        }
                    }
                }

                Button(action: {
                    self.presentingToast = true
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("확인")
                }
                .foregroundColor(Color.white)
                .frame(width: 70, height: 52)
                .background(Color(red: 56/255, green: 124/255, blue: 255/255))
                .padding(21)
                .cornerRadius(2)
                .offset(x: 89, y: 219)
                .toast(isPresented: $presentingToast, dismissAfter: 0.1) {
                    ToastView("스크린샷에 라벨이 추가되었습니다.") {}
                        .frame(width: 272, height: 53, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(20)
                }
                .opacity(filters.count > 0 ? 1 : 0)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:

            HStack {
                Button(action: onClickedBackBtn) {
                    Image("navigation_back_btn")
                }.offset(x: 20)
                Spacer(minLength: 110)
                Text("스크린샷 라벨 추가")
                Spacer(minLength: 35)
                Button(action: {
                    showSearchLabelView = true
                }) {
                    ZStack {
                        Image("navigation_bar_search_btn")
                        NavigationLink(
                            destination: SearchLabelView(),
                            isActive: $showSearchLabelView
                        ) {}
                    }
                }

                Spacer(minLength: 10)
                Button(action: onClickedAddBtn) {
                    Image("navigation_bar_plus_btn")
                    NavigationLink(
                        destination: AddNewLabelView(),
                        isActive: $showAddLabelingView
                    ) {}
                }
            }
        )
    }
}

struct AddLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelingView()
    }
}
