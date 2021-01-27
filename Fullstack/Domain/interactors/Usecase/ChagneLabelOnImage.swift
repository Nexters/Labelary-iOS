//
//  ChagneLabelOnImage.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct ChangeLabelOnImage: Usecase {
    typealias Param = RequestData
    typealias Result = [ImageEntity]

    let labelRepository: LabelRepository
    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.deleteLabel(label: param.beforeLabel, images: param.images)
            .flatMap { _ in imageRepository.requestLabeling(labels: [param.afterLabel], images: param.images) }
            .eraseToAnyPublisher()
    }

    struct RequestData {
        let beforeLabel: LabelEntity
        let afterLabel: LabelEntity
        let images: [ImageEntity]
    }
}
