//
//  CreateLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Combine
import Foundation

struct CreateLabel: Usecase {
    typealias Param = RequestData
    typealias Result = LabelEntity

    let labelRepository: LabelRepository

    func get(param: Param) -> Observable<Result> {
        return labelRepository.createLabel(name: param.text, color: param.color)
    }

    struct RequestData {
        let text: String
        let color: ColorSet
    }
}
