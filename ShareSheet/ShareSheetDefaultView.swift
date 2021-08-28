//
//  ShareSheetDefaultView.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/08/28.
//

import SwiftUI

struct ShareSheetDefaultView: View {
    @State private var show: Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("ico_empty_album")
                .padding(40)
            Text("라벨이 없습니다.")
                .font(Font.H3_BOLD)
                .foregroundColor(Color.primary)
                .padding(14)
            VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
                Text("라벨을 생성하여 스크린샷에")
                Text("라벨을 추가해보세요.")
            }
            .font(Font.B1_REGULAR)
            .foregroundColor(Color.secondary)

            Button(action: {
                self.show = true
            }, label: {
                ZStack {
                    Image("create_label")
                    NavigationLink(
                        destination: AddLabelView(),
                        isActive: $show
                    ) {}.isDetailLink(false)
                }
            }).offset(y: 60)

            Spacer().frame(height: 269)
        }.background(Color.black)
    }
}

