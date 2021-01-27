//
//  BookmarkImage.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct BookmarkImage: Usecase {
    typealias Param = RequestData
    typealias Result = ImageEntity

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.changeBookmark(isActive: param.isActive, image: param.image)
    }

    struct RequestData {
        let isActive: Bool
        let image: ImageEntity
    }
}
