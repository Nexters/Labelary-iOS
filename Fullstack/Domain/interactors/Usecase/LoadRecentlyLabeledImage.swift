//
//  LoadRecentlyLabeledImage.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/19.
//

import Foundation
import Combine

struct LoadRecentlyLabeledImage: Usecase {
    typealias Param = [LabelImageEntity]
    typealias Result = [LabelImageEntity]
    
    let labelImageRepository: LabelImageRepository
    
    func get(param: Param) -> Observable<Result> {
        return labelImageRepository.loadRecentlyLabeledImage(labelImages: param)
            .eraseToAnyPublisher()
    }
}
