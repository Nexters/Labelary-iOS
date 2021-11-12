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

    func get(param: Param = ()) -> Observable<Result> {
        return Publishers.Zip(
            imageRepository.getBookmarkImages(),
            imageRepository.getAllImages()
        ).map { bookmarks, all in
            ResultData(bookmarkedImages: bookmarks, recentlyImages: all)
        }.eraseToAnyPublisher()
    }

    struct ResultData {
        let bookmarkedImages: [ImageEntity]
        let recentlyImages: [ImageEntity]
    }
}
