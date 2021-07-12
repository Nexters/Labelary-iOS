import Combine
import SwiftUI
import ToastUI

// MARK: - functions to give color for GUI

func giveLabelBackgroundColor(color: ColorSet) -> Color {
    switch color {
    case .YELLOW:
        return Color(red: 232/255, green: 194/255, blue: 93/255).opacity(0.15)
    case .RED:
        return Color(red: 199/255, green: 103/255, blue: 97/255).opacity(0.15)
    case .VIOLET:
        return Color(red: 160/255, green: 110/255, blue: 229/255).opacity(0.15)
    case .BLUE:
        return Color(red: 76/255, green: 166/255, blue: 255/255).opacity(0.15)
    case .GREEN:
        return Color(red: 62/255, green: 168/255, blue: 122/255).opacity(0.15)
    case .ORANGE:
        return Color(red: 236/255, green: 145/255, blue: 71/255).opacity(0.15)
    case .PINK:
        return Color(red: 224/255, green: 137/255, blue: 181/255).opacity(0.15)
    case .CONBALT_BLUE:
        return Color(red: 101/255, green: 101/255, blue: 229/255).opacity(0.15)
    case .PEACOCK_GREEN:
        return Color(red: 82/255, green: 204/255, blue: 204/255).opacity(0.15)
    case .GRAY:
        return Color(red: 123/255, green: 131/255, blue: 153/255).opacity(0.15)
    }
}

func giveTextForegroundColor(color: ColorSet) -> Color {
    switch color {
    case .YELLOW:
        return Color(red: 255/255, green: 226/255, blue: 153/255)
    case .RED:
        return Color(red: 255/255, green: 167/255, blue: 153/255)
    case .VIOLET:
        return Color(red: 217/255, green: 194/255, blue: 255/255)
    case .BLUE:
        return Color(red: 178/255, green: 217/255, blue: 255/255)
    case .GREEN:
        return Color(red: 177/255, green: 229/255, blue: 207/255)
    case .ORANGE:
        return Color(red: 255/255, green: 203/255, blue: 161/255)
    case .PINK:
        return Color(red: 255/255, green: 199/255, blue: 227/255)
    case .CONBALT_BLUE:
        return Color(red: 191/255, green: 191/255, blue: 255/255)
    case .PEACOCK_GREEN:
        return Color(red: 161/255, green: 229/255, blue: 229/255)
    case .GRAY:
        return Color(red: 204/255, green: 218/255, blue: 255/255)
    }
}

// MARK: - Each Customed Post-it Label View

struct LabelRowItemView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    var label: LabelEntity

    @State var isSelected: Bool = false
    @Binding var selectedLabels: [LabelEntity]
    @ObservedObject var output = Output()

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
            Text(label.name)
                .font(isSelected ? .custom("AppleSDGothicNeo-Bold", size: 16) : .custom("AppleSDGothicNeo-Medium", size: 16))
                .padding(40)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .cornerRadius(5)
                .edgesIgnoringSafeArea(.horizontal)
                .background(isSelected ? Image("Label_large_Selected_\(output.colorSetToString(color: label.color))") : Image("Label_large_default_\(output.colorSetToString(color: label.color))"))
                .offset(x: isSelected ? -80 : -100)

        })
    }

    class Output: ObservableObject {
        // swtich 문 active label large 로 바꾸는거 하나랑
        func colorSetToString(color: ColorSet) -> String {
            switch color {
            case .YELLOW:
                return "Yellow"
            case .RED:
                return "Red"
            case .VIOLET:
                return "Violet"
            case .BLUE:
                return "Blue"
            case .GREEN:
                return "Green"
            case .ORANGE:
                return "Orange"
            case .PINK:
                return "Pink"
            case .CONBALT_BLUE:
                return "Cobalt_Blue"
            case .PEACOCK_GREEN:
                return "Peacock_Green"
            case .GRAY:
                return "Gray"
            }
        }
    }
}

// MARK: - Parent View

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var output = Output()
    @State var filters: [LabelEntity] = []
    @State var showAddLabelingView = false
    @State var showSearchLabelView = false
    @State var isEdited = false
    @State var presentingToast: Bool = false
    let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))

    init() {
        let cancelBag = CancelBag()
        loadLabelingSelectData.get()
            .sink(receiveCompletion: {
                print("received completion ", $0)
            }, receiveValue: { [self] data in
                print("하나씩 : ", data)
                output.labels = data
            }).store(in: cancelBag)
    }

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

    var backBtn: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("navigation_back_btn")
                    .aspectRatio(contentMode: .fit)
            }
        }
    }

    var body: some View {
        VStack {
            // MARK: - List of Badge Views of selected labels

            VStack(alignment: .leading) {
                if filters.count > 0 {
                    HStack {
                        Text("선택한 라벨")
                        Text("\(filters.count)").foregroundColor(Color.PRIMARY_2)
                            .font(.custom("Apple SD Gothic Neo", size: 14))

                    }.padding(.leading, 15)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            Badge(name: filter.name, color: giveLabelBackgroundColor(color: filter.color), textColor: giveTextForegroundColor(color: filter.color), type: .removable {
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
                        ForEach(output.labels, id: \.self) { label in
                            LabelRowItemView(label: label,
                                             selectedLabels: $filters)
                        }
                    }
                }

                Button(action: {
                    self.presentingToast = true
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("확인").font(.custom("AppleSDGothicNeo-Bold", size: 16))
                }
                .foregroundColor(Color.white)
                .frame(width: 70, height: 52)
                .background(Color(red: 56/255, green: 124/255, blue: 255/255))
                .padding(21)
                .cornerRadius(2)
                .offset(x: 89, y: 219)
                .toast(isPresented: $presentingToast, dismissAfter: 0.1) {
                    ToastView("스크린샷에 라벨이 추가되었습니다.") {
                        // labeling logic
                    }
                    .frame(width: 272, height: 53, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
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

                Spacer(minLength: 100)
                Text("스크린샷 라벨 추가")
                    .font(.custom("Apple SD Gothic Neo", size: 16))
                    .font(Font.body.bold())
                Spacer(minLength: 30)
                Button(action: {
                    showSearchLabelView = true
                }) {
                    ZStack {
                        Image("navigation_bar_search_btn")
                        NavigationLink(
                            destination: SearchLabelView(),
                            isActive: $showSearchLabelView
                        ) {}
                          //  .isDetailLink(false)
                    }
                }

                Button(action: {
                    showAddLabelingView = true
                }) {
                    ZStack {
                        Image("navigation_bar_plus_btn")
                        NavigationLink(
                            destination: AddNewLabelView(),
                            isActive: $showAddLabelingView
                        ) {}
                           // .isDetailLink(false)
                    }
                }
            }
        )
    }

    class Output: ObservableObject {
        @Published var labels: [LabelEntity] = []

        @Published var selectedLabels: [LabelEntity] = []
    }
}
