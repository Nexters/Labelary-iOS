import AlertToast
import Combine
import SwiftUI

// MARK: - functions to give color for GUI Add Labeling View
// inactive color
func giveBorderColor(color: ColorSet) -> Color {
    switch color {
    case .YELLOW:
        return Color(hex: "#E8C15D").opacity(0.15)
    case .RED:
        return Color(hex: "#C76761").opacity(0.19)
    case .VIOLET:
        return Color(hex: "#A06EE5").opacity(0.15)
    case .BLUE:
        return Color(hex: "#4CA6FF").opacity(0.15)
    case .GREEN:
        return Color(hex: "#3EA87A").opacity(0.15)
    case .ORANGE:
        return Color(hex: "#EC9147").opacity(0.15)
    case .PINK:
        return Color(hex: "#E089B").opacity(0.15)
    case .CONBALT_BLUE:
        return Color(hex: "#6565E5").opacity(0.15)
    case .PEACOCK_GREEN:
        return Color(hex: "#52CCCC").opacity(0.15)
    case .GRAY:
        return Color(hex: "#7B8399").opacity(0.15)
    }
}

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

func giveActiveColor(color: ColorSet) -> Color {
    switch color {
    case .YELLOW:
        return Color.LABEL_YELLOW_ACTIVE
    case .RED:
        return Color.LABEL_RED_ACTIVE
    case .VIOLET:
        return Color.LABEL_VIOLET_ACTIVE
    case .BLUE:
        return Color.LABEL_BLUE_ACTIVE
    case .GREEN:
        return Color.LABEL_GREEN_ACTIVE
    case .ORANGE:
        return Color.LABEL_ORANGE_ACTIVE
    case .PINK:
        return Color.LABEL_PINK_ACTIVE
    case .CONBALT_BLUE:
        return Color.LABEL_CONBALT_BLUE_ACTIVE
    case .PEACOCK_GREEN:
        return Color.LABEL_GREEN_ACTIVE
    case .GRAY:
        return Color.LABEL_GRAY_ACTIVE
    }
}

func colorToString(color: ColorSet) -> String {
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

class ShowAddNewLabelView: ObservableObject {
    @Published var pushed = false
}

// MARK: - Parent View

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model = ShowAddNewLabelView()
    @ObservedObject var output = Output()
    @State var filters: [LabelEntity] = []
    @State var showNewAddLabelingView = false
    @State var showSearchLabelView = false
    @State var isEdited = false
    @State var presentingToast: Bool = false
    @State private var showDefaultView: Bool = false // default view switch

    let loadLabelingSelectData = LoadLabelingSelectData(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))
    let requestLabeling = RequestLabeling(imageRepository: ImageRepositoryImpl(cachedDataSource: CachedData()))

    // MARK: - NavigationLink Action funtions

    func onClickedBackBtn() {
        presentationMode.wrappedValue.dismiss()
    }

    func onClickedSearchBtn() {
        showSearchLabelView = true
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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                // MARK: - List of Badge Views of selected labels

                if output.labels.count == 0 {
                    DefaultView()
                } else {
                    VStack(alignment: .leading) {
                        if filters.count > 0 {
                            HStack {
                                Text("추가한 라벨".localized()).foregroundColor(Color.PRIMARY_2)
                                    .font(Font.B2_MEDIUM)
                                Text("\(filters.count)").foregroundColor(Color.KEY)
                                    .font(.custom("Apple SD Gothic Neo", size: 14))

                            }.padding(.leading, 15)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(filters, id: \.self) { filter in
                                    Badge(name: filter.name, color: giveLabelBackgroundColor(color: filter.color), borderColor: giveBorderColor(color: filter.color), textColor: giveTextForegroundColor(color: filter.color), type: .removable {
                                        withAnimation {
                                            if let firstIndex = filters.firstIndex(of: filter) {
                                                filters.remove(at: firstIndex)
                                            }
                                        }
                                    }).transition(.opacity)
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
                            let cancelBag = CancelBag()
                            self.output.selectedLabels = filters
                            needToLabelingData.labelData = self.output.selectedLabels

                            requestLabeling.get(param: RequestLabeling.RequestData(labels: needToLabelingData.labelData, images: needToLabelingData.imageData)).sink(receiveCompletion: { _ in
                                needToLabelingData.imageData.removeAll() // 여기서 초기화해주기
                                needToLabelingData.labelData.removeAll()

                            }, receiveValue: { _ in
                                //  print("이미지 라벨링 데이터", $0)
                            }).store(in: cancelBag)

                            self.presentingToast = true
                            presentationMode.wrappedValue.dismiss()

                        }) {
                            Text("확인".localized()).font(.custom("AppleSDGothicNeo-Bold", size: 16))
                        }
                        .foregroundColor(Color.white)
                        .frame(width: 70, height: 52)
                        .background(Color(red: 56/255, green: 124/255, blue: 255/255))
                        .padding(21)
                        .cornerRadius(2)
                        .offset(x: 69, y: 219)
                        .toast(isPresenting: $presentingToast, duration: 2, tapToDismiss: true, alert: {
                            AlertToast(displayMode: .alert, type: .regular, title: "스크린샷에 라벨이 추가되었습니다.".localized(),
                                       style: .style(backgroundColor: Color.black.opacity(0.5),
                                                     titleColor: Color.PRIMARY_1,
                                                     titleFont: Font.B1_MEDIUM))
                        })
                        .opacity(filters.count > 0 ? 1 : 0)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing:

                HStack {
                    // 뒤로가기버튼
                    Button(action: {
                        self.onClickedBackBtn()
                        needToLabelingData.imageData.removeAll() // 초기화해주기
                        needToLabelingData.labelData.removeAll()
                    }) {
                        Image("navigation_back_btn")
                    }.offset(x: 20)
                        .padding(.trailing, 72)

                    Text("스크린샷 라벨 추가".localized())
                        .font(Font.B1_BOLD)
                        .foregroundColor(Color.PRIMARY_1)
                        .padding(.trailing, 24)

                    // 라벨 검색 버튼
                    Button(action: {
                        showSearchLabelView = true
                    }) {
                        ZStack {
                            NavigationLink(
                                destination: SearchLabelView(),
                                isActive: $showSearchLabelView
                            ) {}.isDetailLink(false)
                            Image("navigation_bar_search_btn")
                        }
                    }

                    Button(action: {
                        self.model.pushed = true
                    }) {
                        ZStack {
                            NavigationLink(
                                destination: AddNewLabelView(),
                                isActive: $model.pushed
                            ) {}.isDetailLink(false)
                            Image("navigation_bar_plus_btn")
                        }
                    }
                }
            )
            .onAppear(perform: {
                let cancelBag = CancelBag()
                loadLabelingSelectData.get()
                    .sink(receiveCompletion: { _ in

                    }, receiveValue: { [self] data in
                        output.labels = data
                    }).store(in: cancelBag)
            })
        }
    }

    class Output: ObservableObject {
        @Published var labels: [LabelEntity] = []
        @Published var selectedLabels: [LabelEntity] = []
    }
}
