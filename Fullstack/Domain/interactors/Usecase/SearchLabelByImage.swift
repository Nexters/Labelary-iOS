//
//  SearchLabelByImage.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/11.
//

import Foundation
import Combine

struct SearchLabelByImage: Usecase {
    typealias Param = ImageEntity
    typealias Result = [LabelEntity]
    
    let labelImageRepository: LabelImageRepository
    
    func get(param: Param) -> Observable<Result> {
        return labelImageRepository.searchLabelByImage(image: param)
    }
}
