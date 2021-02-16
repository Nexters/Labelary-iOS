//
//  SearchBar.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/22.
//

import SwiftUI

struct SearchBar: View {
    @State var keyword: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            CTextField(placeholder: Text("라벨을 검색 해 보세요").foregroundColor(Color.PRIMARY_3), text: $keyword)
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
                    }.padding(.horizontal, 9)
                )
                .onTapGesture {
                    self.isEditing = true
                }
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 40,
                alignment: .topLeading).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(keyword: "")
    }
}
