//
//  SearchLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Combine
import Foundation

struct SearchLabel: Usecase {
    typealias Param = String
    typealias Result = [LabelEntity]

    let labelRepository: LabelRepository

    func get(param: Param) -> Observable<Result> {
        return labelRepository.getLabel(name: param)
    }
}
