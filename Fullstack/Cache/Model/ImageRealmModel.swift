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

    dynamic var labels: List<LabelRealmModel> = List()

//    var labels: Results<LabelRealmModel>? {
//        return realm?.objects(LabelRealmModel.self).filter(NSPredicate(format: "image == %@", self))
//    }

    @objc dynamic var isBookmark: Bool = false

    override static func primaryKey() -> String {
        return "id"
    }
}

extension ImageRealmModel {
    func convertToEntity() -> ImageEntity? {
        print("\(self.id) \(self.labels) image realm model")
        guard !self.id.isEmpty, let source = self.source else {
            return nil
        }

        return ImageEntity(
            source: source,
            id: self.id,
            //      labels: self.labels.mapNotNull { $0.convertToEntity() },
            isBookmark: self.isBookmark,
            isCached: true
        )
    }
}
