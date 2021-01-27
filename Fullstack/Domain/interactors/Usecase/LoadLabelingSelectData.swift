//
//  LoadLabelingSelectData.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Combine
import Foundation

struct LoadLabelingSelectData: Usecase {
    typealias Param = Void
    typealias Result = [LabelEntity]

    let labelRepository: LabelRepository

    func get(param: Param) -> Observable<Result> {
        return labelRepository.getAllLabels()
    }
}
