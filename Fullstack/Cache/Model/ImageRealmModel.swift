//
//  ImageRealmModel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation
import RealmSwift

class ImageRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var source: String?

    @objc dynamic var isBookmark: Bool = false

    override static func primaryKey() -> String {
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
            isBookmark: self.isBookmark,
            isCached: true
        )
    }
}
