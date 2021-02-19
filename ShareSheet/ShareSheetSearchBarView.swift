//
//  ShareSheetSearchBarView.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/17.
//

import SwiftUI

struct ShareSheetSearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("  라벨을 검색하거나 추가해 보세요.", text: $text)
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color.DEPTH_2)
                .cornerRadius(2)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
        }
    }
}

struct ShareSheetSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetSearchBarView(text: .constant(""))
    }
}