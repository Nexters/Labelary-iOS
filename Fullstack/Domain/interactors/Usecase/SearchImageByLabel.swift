//
//  SearchImageByLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct SearchImageByLabel: Usecase {
    typealias Param = [LabelEntity]
    typealias Result = [LabelImageEntity]

    let labelImageRepository: LabelImageRepository

    func get(param: Param) -> Observable<Result> {
        return labelImageRepository.getImages(labels: param)
    }
}
