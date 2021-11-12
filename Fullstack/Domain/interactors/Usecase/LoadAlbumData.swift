//
//  LoadAlbumData.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/05.
//

import Foundation
import Combine

struct LoadAlbumData: Usecase {
    typealias Param = LabelEntity
    typealias Result = [LabelImageEntity]
    
    let labelImageRepository: LabelImageRepository
    
    func get(param: Param) -> Observable<Result> {
        return labelImageRepository.loadAlbumData(label: param)
            .eraseToAnyPublisher()
    }
}
