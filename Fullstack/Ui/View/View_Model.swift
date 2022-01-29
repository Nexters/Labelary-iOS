//
//  Model.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import Combine
import Foundation
import Photos
import UIKit

struct ImageHasher: Identifiable {
    var id: String
    var image: ImageEntity

    init(imageEntity: ImageEntity) {
        self.image = imageEntity
        self.id = self.image.id
    }
}

struct LabelWrapper {
    var label: LabelEntity
    init(labelEntity: LabelEntity) {
        self.label = labelEntity
    }
}

class UnlabeledImageViewModel: ObservableObject {
    @Published var image: ImageEntity
    @Published var uiImage: UIImage? = nil

    init(image: ImageEntity) {
        self.image = image
    }

    func reload() {
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [self.image.source], options: nil).firstObject
        if asset == nil {
            self.uiImage = UIImage()
            // delete 하면 ??

            print("reloadFail")
        } else {
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: asset!.pixelWidth/10, height: asset!.pixelHeight/10), contentMode: .aspectFit, options: options, resultHandler: { result, _ in
                if result != nil {
                    print("reload\(result?.size)")
                    self.uiImage = result!
                }
            })
        }
    }
}

class ImageViewModel: ObservableObject {
    @Published var image: ImageEntity
    @Published var uiImage: UIImage? = nil
    @Published var status = Status.IDLE

    init(image: ImageEntity) {
        self.image = image
    }

    func reload() {
        let options = PHImageRequestOptions()
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [self.image.source], options: nil).firstObject
        if asset == nil {
            self.uiImage = UIImage()
            print("reloadFail")

        } else {
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: asset!.pixelWidth, height: asset!.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { result, _ in
                if result != nil {
                    self.uiImage = result!
                }
            })
        }
    }

    enum Status {
        case IDLE
        case EDITING
        case SELECTING
    }
}
