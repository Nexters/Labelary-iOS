<<<<<<< HEAD
=======
//
//  AddLabelingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
// 라벨링 -> 추가

>>>>>>> f7ca2482de74d5f5fce47d667586be2be0eef0e0
import SwiftUI

struct Badge: View {
    var name: String
    var color = Color(red: 255/255, green: 255/255, blue: 255/255)
    var type: BadgeType = .normal

    enum BadgeType {
        case normal
        case removable(() -> ())
    }

<<<<<<< HEAD
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
=======
struct SelectedLabelView: View {
    var body: some View {
        HStack {
            List {
                Button(action: {
                    // Deselect the label
                }, label: {
                    Text("카톡대화")
                })
>>>>>>> f7ca2482de74d5f5fce47d667586be2be0eef0e0
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color)
        .cornerRadius(8)
    }
}

struct Label: Identifiable {
    var id = UUID()
    var label: String
}

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var filters: [String] = [
    ]

    @State var labels = [
        Label(label: "UX/UI 디자인"),
        Label(label: "카톡캡쳐"),
        Label(label: "헤어스타일"),
        Label(label: "엽사"),
        Label(label: "게임스샷"),
        Label(label: "UX/UI 디자인")
    ]
<<<<<<< HEAD

    @State var selectedLabels = [Label]()

    var body: some View {
        VStack {
            VStack {
                Text("선택된 라벨 \(filters.count)")
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

=======
    
    var body: some View {
        VStack {
            HStack {
                Text("라벨 들 넣을 공간")
            }
                
>>>>>>> f7ca2482de74d5f5fce47d667586be2be0eef0e0
            List(labels) { label in
                Button(action: {
                    filters.append(label.label)
                    print(filters)

                }, label: {
                    Text(label.label)
                        .padding()
                        .frame(width: 252, height: 50, alignment: .trailing)
                        .foregroundColor(.white)
                        .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                        .cornerRadius(8)
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
<<<<<<< HEAD
            HStack {
                Button(action: onclickedBackBtn) {
                    Image(systemName: "arrow.left")
                    Text("라벨 추가")
                }
                Spacer(minLength: 220)
                Button(action: onclickedBackBtn) {
                    Image(systemName: "magnifyingglass")
                }

                Button(action: onclickedBackBtn) {
                    Image(systemName: "plus")
                }
=======
                                    
            Button(action: onclickedBackButton) {
                Image(systemName: "arrow.left")
>>>>>>> f7ca2482de74d5f5fce47d667586be2be0eef0e0
            }
        )
    }
    
<<<<<<< HEAD
    func onclickedBackBtn() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

func onClickedSearchBtn() {}

func onClickedAddBtn() {}
=======
    func onclickedBackButton() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
>>>>>>> f7ca2482de74d5f5fce47d667586be2be0eef0e0

struct AddLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelingView()
    }
}
