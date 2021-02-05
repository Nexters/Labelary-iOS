//
//  SearchLabelView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/02.
// 1_라벨링_라벨검색

import SwiftUI

struct SearchLabelView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        SearchBar(text: .constant(""))

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
}

struct SearchLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLabelView()
    }
}
