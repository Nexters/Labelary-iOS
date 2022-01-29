//
//  SearchBar.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import Foundation
import SwiftUI

struct SearchBarButton: View {
    var body: some View {
        HStack {
            Text("스크린샷 검색 ")
        }
        .padding(10)
        .padding(.horizontal, 24)
        .background(Color.DEPTH_3)
        .cornerRadius(4)
        .foregroundColor(Color.PRIMARY_2)
        .font(Font.B1_REGULAR)
        .overlay(
            HStack {
                Image("Icon_search")
                    .foregroundColor(.red)
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                Spacer()
            }.padding(.horizontal, 9)
        )
    }
}

struct SearchBar: View {
    @Binding var keyword: String
    @Binding var isEditing: Bool

    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = {}

    var body: some View {
        HStack(alignment: .center) {
            CLabelSearchField(
                placeholder: Text("라벨을 검색 해 보세요").foregroundColor(Color.PRIMARY_3),
                text: $keyword,
                commit: self.commit,
                isEditing: $isEditing
            )
            .padding(10)
            .padding(.horizontal, 24)
            .background(Color.DEPTH_2)
            .cornerRadius(4)
            .foregroundColor(Color.PRIMARY_2)
            .font(Font.B1_REGULAR)
            .overlay(
                HStack {
                    Image("Icon_search")
                        .foregroundColor(.red)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    Spacer()
                    Image("btn_icon_cancel")
                        .opacity(keyword == "" ? 0 : 1)
                        .onTapGesture {
                            self.keyword.removeAll()
                        }
                }.padding(.horizontal, 9)
            )

            //  if isEditing {
//                Text("취소")
//                    .font(Font.B1_MEDIUM)
//                    .foregroundColor(Color.PRIMARY_1)
//                    .padding(.leading, 12)
//                    .onTapGesture {
//                        isEditing = false
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    }
            //     }
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
