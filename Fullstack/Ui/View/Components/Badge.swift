//
//  Badge.swift
//  Fullstack
//
//  Created by 우민지 on 2021/02/16.
//

import SwiftUI

// MARK: - Custom small label badge view

struct Badge: View {
    var name: String
    var color: Color
    var borderColor: Color // 새로 추가함
    var textColor: Color
    var type: BadgeType = .normal
    @State var showSelf: Bool = false

    enum BadgeType {
        case normal
        case removable(() -> ())
    }

    var body: some View {
        ZStack {
            HStack {
                Text(name).foregroundColor(textColor)

                switch type {
                case .removable(var callback):
                    Image("btn_icon_cancel")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .font(Font.caption.bold())
                        .onTapGesture {
                            callback()
                        }
                
                     default:
                    AddLabelingView()
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .border(borderColor)
            .cornerRadius(2)
        }
    }
}
