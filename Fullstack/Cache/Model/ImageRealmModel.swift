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
    dynamic var labels: List<LabelRealmModel> = List()
    dynamic var isBookmark: Bool = false

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ImageRealmModel {
    func convertToEntity() -> ImageEntity? {
        guard !self.id.isEmpty, let source = self.source else {
            return nil
        }

        return ImageEntity(
            source: source,
            id: self.id,
            labels: self.labels.mapNotNull { $0.convertToEntity() },
            isBookmark: self.isBookmark,
            isCached: true
        )
    }
}
