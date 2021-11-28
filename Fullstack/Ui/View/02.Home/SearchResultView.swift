//
//  SearchResultView.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/29.
//

import SwiftUI

struct SearchResultView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                ScrollView(.horizontal) {
                    ForEach(searchSelectedLabels.selectedLabels, id: \.self) { item in
                        Badge(name: item.name, color: giveLabelBackgroundColor(color: item.color), textColor: giveTextForegroundColor(color: item.color), type: .removable {
                            withAnimation {
                                if let firstIndex = searchSelectedLabels.selectedLabels.firstIndex(of: item) {
                                    searchSelectedLabels.selectedLabels.remove(at: firstIndex)
                                }
                            }
                        }).transition(.opacity)
                    }
                }
                Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                    Text("편집")
                })
            }
            
            HStack {
                Text("스크린샷 검색 결과")
                Text("6") // 결과에 해당하는 스크린샷 개수
            }

        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("ico_cancel")
                })

                Text("검색한 스크린샷").padding(.leading, 20)
            }
            )
    }
}
