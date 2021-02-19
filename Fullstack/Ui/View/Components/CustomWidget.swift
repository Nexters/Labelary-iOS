//
//  CustomWidget.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/14.
//

import Foundation
import Photos
import PhotosUI
import SwiftUI

struct CLabelSearchField: View {
    var placeholder: Text
    @Binding var text: String
    var commit: () -> () = {}
    @Binding var labels: [LabelEntity]
    @Binding var isEditing: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty, !isEditing { placeholder }
            HStack {
                if !labels.isEmpty && isEditing {
                    ScrollView(.horizontal, showsIndicators: false) {
                        buildLabels(labels: labels)
                    }.frame(maxWidth: min(CGFloat(self.labels.count) * 60, 300))
                }
                TextField(
                    "",
                    text: $text,
                    onEditingChanged: { isEditing in
                        print("asdasdasd \(isEditing)")
                        self.isEditing = isEditing
                    }, onCommit: commit
                )
                Spacer()
            }
        }
    }

    @ViewBuilder
    func buildLabels(labels: [LabelEntity]) -> some View {
        HStack {
            ForEach(labels, id: \.id) { label in
                Text(label.name).padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
                    .font(Font.B2_MEDIUM)
                    .background(label.color.deactive)
                    .foregroundColor(label.color.text)
                    .cornerRadius(3)
                    .onTapGesture {
                        if let index = self.labels.firstIndex(of: label) {
                            self.labels.remove(at: index)
                        }
                    }
            }
        }
    }
}

struct ImageView: View {
    var img: ImageEntity
    @State var displayedImage: UIImage? = nil

    var body: some View {
        Image(uiImage: displayedImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear(perform: {
                self.loadImage()
            })
    }

    private func loadImage() {
        switch img.source {
        case .Cache(let asset):
            let options = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
            options.resizeMode = PHImageRequestOptionsResizeMode.fast

            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { result, _ in
                if result != nil {
                    self.displayedImage = result!
                }
            })
        case .Remote: break
        }
    }
}
