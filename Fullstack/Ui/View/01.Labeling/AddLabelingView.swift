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
                    .frame(width: 8, height: 8, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
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

struct Label: Identifiable {
    var id = UUID()
    var label: String
}

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var filters: [String] = []
    @State var labels = [
        Label(label: "UX/UI 디자인"),
        Label(label: "헤어스타일"),
        Label(label: "엽사"),
        Label(label: "게임스샷"),
        Label(label: "UX/UI 디자인")
    ]
    @State var isSelected: Bool = false
    @State var showAddLabelingView = false
    @State var showSearchLabelView = false

    func selectLabel() {
        self.isSelected = true
    }

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

            List(labels) { label in

                Button(action: {}, label: {
                    Text(label.label)
                        .padding()
                        .frame(width: 252, height: 50, alignment: .trailing)
                        .foregroundColor(.white)
                        .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                        .cornerRadius(4)
                        .edgesIgnoringSafeArea(.horizontal)

                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:

            HStack {
                Button(action: onClickedBackBtn) {
                    Image(systemName: "arrow.left")
                    Text("라벨 추가")
                }
                Spacer(minLength: 220)
             
                Button(action: onClickedSearchBtn) {
                    Image(systemName: "magnifyingglass")
                    NavigationLink(
                        destination: AddNewLabelView(),
                        isActive: $showAddLabelingView
                    ) {}
                }
                Spacer(minLength: 20)
                Button(action: onClickedAddBtn) {
                    Image(systemName: "plus")
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
