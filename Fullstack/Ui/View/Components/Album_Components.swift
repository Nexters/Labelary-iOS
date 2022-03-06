//
//  Album_Components.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/09.
//

import Combine
import Foundation
import SwiftUI

struct CAlbum: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Image(viewModel.images.isEmpty ? "" : "")
            Spacer(minLength: 12)

        }.frame(width: 160, height: 225, alignment: .leading)
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    class ViewModel: ObservableObject {
        @Published
        var images: [ImageEntity]
        @Published
        var label: LabelEntity

        init(images: [ImageEntity], label: LabelEntity) {
            self.images = images
            self.label = label
        }
    }
}
