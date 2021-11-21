//
//  DeleteImageFromLabel.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/21.
//

import Foundation

struct DeleteImageFromLabel: Usecase {
    typealias Param = [ImageEntity]
    typealias Result = [LabelImageEntity]

    let imageRepository: ImageRepository
    
    func get(param: [ImageEntity]) -> Observable<Result> {
        return imageRepository.deleteImageFromLabel(images: param)
    }
}
