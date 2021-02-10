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
                    .frame(width: 8, height: 8, alignment:  .center)
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
    var color: String = "yellow"
}

struct LabelRowItemView: View {
    var label: Label
    var selectedLabel: String {
        print(self.label.label)
        return self.label.label
    }

    @State var isSelected = false
    @State var filter: [String] = []
    var body: some View {
        Button(action: {
            self.isSelected.toggle()

            if isSelected {
                selectedLabel
            } else {}

        }, label: {
            Text(label.label)
                .padding()
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.horizontal)
                .offset(x: -20)
                .background(isSelected ? Image("Label_large_Selected_Yellow") : Image("Label_large_default_Yellow"))
                .offset(x: -80)

        })
    }
}

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var filters: [String] = []
    @State var labels = [
        Label(label: "UX/UI 디자인"),
        Label(label: "헤어스타일"),
        Label(label: "엽사"),
        Label(label: "게임스샷"),
        Label(label: "OOTD")
    ]

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
                            Badge(name: filter, color: Color(red: 255/255, green: 255/255, blue: 255/255), type: .removable {
                                withAnimation {
                                    self.filters.removeAll { $0 == filter }
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
                        LabelRowItemView(label: label)
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
                        isActive: $showAddLabelingView
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
