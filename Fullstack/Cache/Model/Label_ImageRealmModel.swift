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
    @objc dynamic var id: String = ""
    @objc dynamic var image: ImageRealmModel? = nil
    dynamic var labels: List<LabelRealmModel> = List()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension LabelImageRealmModel {
    func convertToEntity() -> LabelImageEntity? {
        return LabelImageEntity(id: id, image: image!.convertToEntity()!, labels: labels.mapNotNull { $0.convertToEntity() })
    }
}
