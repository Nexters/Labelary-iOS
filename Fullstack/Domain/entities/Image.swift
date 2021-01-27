//
//  Image.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

struct ImageEntity: Entity {
    let source: Source
    var id: String
    let metaData: ImageMetadataEntity
    var labels: [LabelEntity]
    var isBookmark: Bool

    enum Source {
        case Remote(url: String)
        case Cache(path: String)
    }
}

extension Array where Element == ImageEntity {
    func execlude(filter: [ImageEntity]) -> [ImageEntity] {
        self.filter { item in filter.contains(item) }
    }
}
