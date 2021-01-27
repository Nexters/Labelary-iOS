//
//  LoadAlbumData.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Combine
import Foundation

struct LoadSearchMainData: Usecase {
    typealias Param = Void
    typealias Result = ResultData

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return Publishers.Zip(
            imageRepository.getBookmarkImages(),
            imageRepository.getAllImages()
        ).map {
            ResultData(bookmarkedImages: $0, recentlyImages: $1)
        }.eraseToAnyPublisher()
    }

    struct ResultData {
        let bookmarkedImages: SearchResponse
        let recentlyImages: SearchResponse
    }
}
