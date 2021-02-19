//
//  ShareSheetBadgeView.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/17.
//

import SwiftUI

// MARK: - Custom small label badge view

struct Badge: View {
    var name: String
    var color: Color
    var textColor: Color
    var type: BadgeType = .normal

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
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 8, height: 8, alignment: .center)
                        .font(Font.caption.bold())
                        .onTapGesture {
                            callback()
                        }

                default:

                    ShareSheetSearchBarView(text: .constant(""))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .cornerRadius(2)
        }
    }
}
