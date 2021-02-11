import SwiftUI

struct Badge: View {
    var name: String
    var color = Color(red: 255/255, green: 255/255, blue: 255/255)
    var type: BadgeType = .normal

    enum BadgeType {
        case normal
        case removable(() -> ())
    }

    var body: some View {
        HStack {
            Text(name)

            switch type {
            case .removable(let callback):
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8, alignment: .center)
                    .font(Font.caption.bold())
                    .onTapGesture {
                        callback()
                    }
            default:
                AddLabelingView()
            }
        }
    }
}

struct Label: Hashable {
    var id = UUID()
    var label: String
    var color: String
}

//Child view
struct LabelRowItemView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    var label: Label

    @State var isSelected = false
    @Binding var selectedLabels:[Label]

    var body: some View {
        Button(action: {
            self.isSelected.toggle()
            if isSelected {
                selectedLabels.append(label)
              
            } else {}
        }, label: {
            Text(label.label)
                .padding(20)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.horizontal)
                .offset(x: -20)
                .background(isSelected ? Image("Label_large_Selected_\(label.color)") : Image("Label_large_default_\(label.color)"))
                .offset(x: isSelected ? -80 : -100)

        })
    }
}

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var labels = [
        Label(label: "UX/UI 디자인", color: "Yellow"),
        Label(label: "헤어스타일", color: "Red"),
        Label(label: "엽사", color: "Violet"),
        Label(label: "게임스샷", color: "Blue"),
        Label(label: "OOTD", color: "Orange")
    ]
    
    @State var filters:[Label] = []
    
    @State var showAddLabelingView = false
    @State var showSearchLabelView = false
    @State var isSelected = false

    func onClickedBackBtn() {
        self.presentationMode.wrappedValue.dismiss()
    }

    func onClickedSearchBtn() {
        self.showSearchLabelView = true
    }

    func onClickedAddBtn() {
        self.showAddLabelingView = true
    }

    var body: some View {
        VStack {
            VStack {
                if filters.count > 0 {
                    Text("선택된 라벨 \(filters.count)")
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            Badge(name: filter.label, color: Color(red: 255/255, green: 255/255, blue: 255/255), type: .removable {
                                withAnimation {
                                    filters.removeAll { $0 == filter }
                                }
                            })
                                .transition(.opacity)
                        }
                    }
                }
            }

            ScrollView {
                LazyVStack {
                    ForEach(labels, id: \.self) { label in
                        LabelRowItemView(label: label, selectedLabels: $filters)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:

            HStack {
                Button(action: onClickedBackBtn) {
                    Image("navigation_back_btn")
                }
                Spacer(minLength: 110)
                Text("라벨 선택")
                Spacer(minLength: 35)
                Button(action: onClickedSearchBtn) {
                    Image("navigation_bar_search_btn")
                    NavigationLink(
                        destination: AddNewLabelView(),
                        isActive: $showSearchLabelView
                    ) {}
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

public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }.onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}

public extension View {
    func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}

struct AddLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelingView()
    }
}
