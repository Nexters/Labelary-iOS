//
//  AddNewLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨추가 화면

import SwiftUI

struct AddNewLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""

    @State var keyboardHeight: CGFloat = 0
    @State var keyboardAnimationDuration: TimeInterval = 0
    

    var body: some View {
        VStack {
            TextField("새 라벨 이름 입력", text: $name)
                .padding(60)
                .frame(width: 252, height: 50, alignment: .trailing)
                .foregroundColor(.white)
                .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.black)
                            .frame(width: 20, height: 20, alignment: .leading)
                            .padding(.leading, -100)
                    }
                )
        }
        .animation(.easeOut(duration: keyboardAnimationDuration))
            .onReceive(
              NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                .receive(on: RunLoop.main),
              perform: updateKeyboardHeight
            )
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
            Button(action: onClickedBackBtn) {
                Image(systemName: "arrow.left")
            }
        
        )
    }

    func onClickedBackBtn() {
        self.presentationMode.wrappedValue.dismiss()
    }

    func updateKeyboardHeight(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        keyboardAnimationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        
        guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if keyboardFrame.origin.y == UIScreen.main.bounds.height {
            keyboardHeight = 0
        } else {
            keyboardHeight = keyboardFrame.height
        }
    }
}

struct AddNewLabelView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLabelView()
    }
}
