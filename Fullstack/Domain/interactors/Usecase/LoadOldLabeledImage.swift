//
//  LoadOldLabeledImage.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/19.
//

import Foundation
import Combine

struct LoadOldLabeledImage: Usecase {
    typealias Param = [LabelImageEntity]
    typealias Result = [LabelImageEntity]
    
    let labelImageRepository: LabelImageRepository
    
    func get(param: [LabelImageEntity]) -> Observable<[LabelImageEntity]> {
        return labelImageRepository.loadOldLabeledImage(labelImages: param)
            .eraseToAnyPublisher()
    }
}
