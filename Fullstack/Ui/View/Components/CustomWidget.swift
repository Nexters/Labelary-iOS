//
//  CustomWidget.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/14.
//

import Foundation
import SwiftUI

struct CTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = {}

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
