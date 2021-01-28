//
//  ImageRealmModel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation
import RealmSwift

class ImageRealmModel: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var source: ImageEntity.Source?
    dynamic var metaData: ImageMetadataEntity?
    dynamic var labels: List<LabelRealmModel> = List()
    dynamic var isBookmark: Bool = false

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ImageRealmModel {
    func convertToEntity() -> ImageEntity? {
        guard !self.id.isEmpty, let source = self.source, let metaData = self.metaData else {
            return nil
        }

        return ImageEntity(
            source: source,
            id: self.id,
            metaData: metaData,
            labels: self.labels.mapNotNull { $0.convertToEntity() },
            isBookmark: self.isBookmark,
            isCached: true
        )
    }
}
