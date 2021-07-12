import RealmSwift
import SwiftUI
import UIKit

// MARK: - ADD Keyboard Animation

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var becameFirstResponder = true

        init(text: Binding<String>) {
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        let customFont = UIFont(name: (textField.font?.fontName)!, size: 28.0)!

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "입력완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(textField.doneButtonTapped(button:)))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.setItems([doneButton], animated: true)
        textField.font = customFont
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        textField.inputAccessoryView = toolBar
        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}

extension UITextField {
    @objc func doneButtonTapped(button: UIBarButtonItem) {
        resignFirstResponder()
    }
}

struct AddNewLabelView: View {
    let labelButtons = ["Yellow", "Red", "Violet", "Blue", "Green", "Orange", "Pink", "Cobalt_Blue", "Peacock_Green", "Gray"]
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""
    @State var selectedIndex: Int? = -1
    @State var isSelected: Bool = false
    @State private var selectedColor: String = ""
    @State private var color: ColorSet = .RED()
    @State private var action: Bool = false

    let realm: Realm = try! Realm()
    let createLabel = CreateLabel(labelRepository: LabelingRepositoryImpl(cachedDataSource: CachedData()))

    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] // realm db 파일 어디있는지 출력
    let cancelbag = CancelBag()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("라벨명").font(.custom("Apple SD Gothic Neo", size: 12))
                    .frame(width: 37, height: 20, alignment: .leading)
                    .padding(7)

                FirstResponderTextField(text: $text, placeholder: "라벨명을 입력해주세요.")
                    .frame(width: 350, height: 40, alignment: .trailing)
                    .foregroundColor(.white)
                    .padding(7)

                Text("라벨 컬러 선택").font(.custom("Apple SD Gothic Neo", size: 12))
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
                                do {
                                    try realm.write {
                                        createLabel.get(param: CreateLabel.RequestData(text: text, color: color))
                                            .sink(receiveCompletion: { _ in
                                                print("complete create label")

                                            }, receiveValue: { data in
                                                
                                                print("AddNewLabelView에서 데이타 : ")
                                                print(data)
                                                
                                            }).store(in: cancelbag)
                                    }

                                } catch {
                                    print(error)
                                }

                                self.action = true
                            }
                        }
                }
                NavigationLink(
                    destination: AddLabelingView(),
                    isActive: self.$action
                ) {}
            }
        }
        Spacer()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button(action: onClickedBackBtn) {
                        Image("navigation_back_btn")
                    }
                    Spacer(minLength: 80)
                    Text("라벨 생성")
                    Spacer()
                })
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
            self.newLabel = newLabel // imageData from the url
        }
    }
}
