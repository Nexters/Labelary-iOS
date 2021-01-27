//
//  DeleteLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct DeleteLabel: Usecase {
    typealias Param = LabelEntity
    typealias Result = String

    let labelRepository: LabelRepository

    func get(param: Param) -> Observable<Result> {
        return labelRepository.deleteLabel(label: param)
    }
}
