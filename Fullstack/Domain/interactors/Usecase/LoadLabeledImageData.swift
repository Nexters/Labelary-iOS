//
//  LoadLabeledImageData.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Combine
import Foundation

struct LoadLabeledImageData: Usecase {
    typealias Param = Void
    typealias Result = [LabelImageEntity]

    let labelImageRepository: LabelImageRepository

    func get(param: Param = ()) -> Observable<Result> {
        return labelImageRepository.loadlabeledImageData().eraseToAnyPublisher()
    }
}
