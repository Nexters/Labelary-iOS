//
//  ChangeFromLabelToLabel.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/21.
//

import Foundation

struct ChangeFromLabelToLabel: Usecase {
    typealias Param = RequestData
    typealias Result = [LabelImageEntity]

    let labelImageRepository: LabelImageRepository

    func get(param: RequestData) -> Observable<[LabelImageEntity]> {
        return labelImageRepository.changeFromLabelToLabel(images: param.images, fromLabel: param.fromLabel, toLabel: param.toLabel)
    }

    struct RequestData {
        let images: [ImageEntity]
        let fromLabel: LabelEntity
        let toLabel: LabelEntity
    }
}
