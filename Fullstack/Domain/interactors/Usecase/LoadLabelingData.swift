//
//  LoadLabelingData.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Combine
import Foundation

struct LoadLabelingData: Usecase {
    typealias Param = [ImageEntity]
    typealias Result = [ImageEntity]

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.getUnLabeledImages(filtered: param)
            .eraseToAnyPublisher()
    }
}
