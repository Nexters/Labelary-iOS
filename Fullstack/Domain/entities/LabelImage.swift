//
//  LabelImage.swift
//  Fullstack
//
//  Created by 우민지 on 2021/10/31.
//

import Foundation
// 관계 테이블

struct LabelImageEntity: Entity {
    let id: String // Image id
    var image : ImageEntity
    var labels: [LabelEntity]
}
