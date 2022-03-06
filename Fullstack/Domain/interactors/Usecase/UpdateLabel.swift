//
//  UpdateLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct UpdateLabel: Usecase {
    typealias Param = LabelEntity
    typealias Result = LabelEntity

    let labelRepository: LabelRepository

    func get(param: Param) -> Observable<Result> {
        return labelRepository.updateLabel(label: param)
    }
}
