//
//  AddLabelingView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
// 라벨링 -> 추가

import SwiftUI

struct Label: Identifiable {
    var id = UUID()
    var label: String
}

var selectedLabels = [Label]()

struct SelectedLabelView: View {
    var body: some View {
        HStack {
            List {
                Button(action: {
                    // Deselect the label
                }, label: {
                    Text("카톡대화")
                })
            }
        }
    }
}

struct AddLabelingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var labels = [
        Label(label: "UX/UI 디자인"),
        Label(label: "카톡캡쳐"),
        Label(label: "헤어스타일"),
        Label(label: "엽사"),
        Label(label: "게임스샷"),
        Label(label: "UX/UI 디자인"),
        Label(label: "UX/UI 디자인"),
        Label(label: "UX/UI 디자인")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("라벨 들 넣을 공간")
            }
                
            List(labels) { label in
                Button(action: {}, label: {
                    Text(label.label)
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                    
            Button(action: onclickedBackButton) {
                Image(systemName: "arrow.left")
            }
        )
    }
    
    func onclickedBackButton() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddLabelingView_Previews: PreviewProvider {
    static var previews: some View {
        AddLabelingView()
    }
}
