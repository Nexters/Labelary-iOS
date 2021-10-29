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
    @objc dynamic var image = ImageRealmModel()
    dynamic var labels: List<LabelRealmModel> = List()
    
}
