//
//  LoadLabelingData.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation
import Combine

struct LoadLabelingData : Usecase {
 
    typealias Param = Array<ImageEntity>
    typealias Result = Array<ImageEntity>
    
    let imageRepository : ImageRepository
    
    func get(param : Param) -> Observable<Result> {
        return imageRepository.getUnLabeledImages()
            .map{ $0.execlude(filter : param) }
            .eraseToAnyPublisher()
    }
}
