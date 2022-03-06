//
//  LabelBadge.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/20.
//

import SwiftUI

struct LabelBadge: View {
    var name: String
    var color: Color
    var textColor: Color
    @State var showSelf: Bool = false

    var body: some View {
        ZStack {
            HStack {
                Text(name).foregroundColor(textColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .cornerRadius(2)
        }
    }
}
