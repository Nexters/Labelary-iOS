//
//  SearchImageByLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

struct SearchImageByLabel: Usecase {
    typealias Param = RequestData
    typealias Result = SearchResponse

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.getImages(labels: param.labels, pageId: param.pageId)
    }

    struct RequestData {
        let labels: [LabelEntity]
        let pageId: Int
    }
}
