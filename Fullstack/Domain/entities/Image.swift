//
//  Image.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation
import Photos

struct ImageEntity: Entity {
    let source: Source
    var id: String
    var labels: [LabelEntity]
    var isBookmark: Bool = false
    var isCached: Bool = false
    var createdAt: Date?

    enum Source {
        case Remote(url: String)
        case Cache(asset: PHAsset)
    }
}

extension Array where Element == ImageEntity {
    func execlude(filter: [ImageEntity]) -> [ImageEntity] {
        self.filter { item in filter.contains(item) }
    }
}

extension PHAsset {
    func toEntity() -> ImageEntity {
        return ImageEntity(
            source: ImageEntity.Source.Cache(asset: self),
            id: localIdentifier,
            labels: [],
            isBookmark: isFavorite,
            createdAt: creationDate
        )
    }
}
