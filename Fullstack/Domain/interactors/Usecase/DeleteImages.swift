//
//  DeleteImages.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct DeleteImages: Usecase {
    typealias Param = [ImageEntity]
    typealias Result = [String]

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.deleteImages(images: param)
    }
}
