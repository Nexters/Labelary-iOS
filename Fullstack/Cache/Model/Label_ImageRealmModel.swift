//
//  Label_ImageRealmModel.swift
//  Fullstack
//
//  Created by 우민지 on 2021/10/29.
//

import Foundation
import RealmSwift
// 관계 테이블
class LabelImageRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var image: ImageRealmModel?
    dynamic var labels: List<LabelRealmModel> = List()
    @objc dynamic var createdAt: Date?
    dynamic var lastSearchedAt: Date?
    override static func primaryKey() -> String {
        return "id"
    }
}

extension LabelImageRealmModel {
    func convertToEntity() -> LabelImageEntity? {
        guard !self.id.isEmpty, let createdAt = self.createdAt else {
            return nil
        }

        return LabelImageEntity(id: self.id,
                                image: self.image!.convertToEntity()!,
                                labels: self.labels.mapNotNull { $0.convertToEntity() },
                                createdAt: createdAt,
                                lastSearchedAt: self.lastSearchedAt)
    }
}
