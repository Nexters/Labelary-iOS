//
//  Label.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

struct LabelEntity: Entity {
    let id: String
    var name: String
    var color: ColorSet
    var images: [ImageEntity]
    let createdAt: Date
    var lastSearchedAt: Date
}
