//
//  LabelRealmModel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation
import RealmSwift

class LabelRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""

    var colorType: ColorSet {
        get {
            return ColorSet(rawValue: self.color) ?? ColorSet.VIOLET()
        }
        set {
            self.color = newValue.rawValue
        }
    }


//    var image: ImageRealmModel { return images.first!}


    @objc dynamic var createdAt: Date?
    dynamic var lastSearchedAt: Date?

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension LabelRealmModel {
    func convertToEntity() -> LabelEntity? {
        guard !self.id.isEmpty, !self.name.isEmpty, let createdAt = self.createdAt else {
            return nil
        }

        return LabelEntity(
            id: self.id,
            name: self.name,
            color: ColorSet(rawValue: self.color)!,
        //    images: self.images.mapNotNull { $0.convertToEntity() },
            createdAt: createdAt,
            lastSearchedAt: self.lastSearchedAt,
            isCached: true
        )
    }
}
