//
//  DeleteLabelFromImage.swift
//  Fullstack
//
//  Created by 우민지 on 2021/09/20.
//

import Combine
import Foundation

struct DeleteLabelFromImage: Usecase {
    typealias Param = RequestData
    typealias Result = [String]

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.deleteLabel(labels: param.labels, images: param.images)
    }

    struct RequestData {
        var labels: [LabelEntity] = []
        var images: [ImageEntity] = []
    }
}
