//
//  Model.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/19.
//

import Foundation

struct ImageWrapper {
    var image: ImageEntity
    var status: Status

    init(imageEntity: ImageEntity, status: Status) {
        self.image = imageEntity
        self.status = status
    }

    enum Status {
        case IDLE
        case EDITING
        case SELECTING
    }
}
