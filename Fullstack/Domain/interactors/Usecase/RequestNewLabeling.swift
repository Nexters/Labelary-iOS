//
//  RequestNewLabeling.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Foundation
import Combine

struct RequestNewLabeling: Usecase {
    typealias Param = RequestData
    typealias Result = [LabelImageEntity]

    let labelImageRepository: LabelImageRepository

    func get(param: Param) -> Observable<Result> {
        return labelImageRepository.requestNewLabeling(labels: param.labels, images: param.images)
    }

    struct RequestData {
        let labels: [LabelEntity]
        let images: [ImageEntity]
    }
}
