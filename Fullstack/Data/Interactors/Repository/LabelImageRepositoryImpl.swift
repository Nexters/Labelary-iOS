//
//  LabelImageRepositoryImpl.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Foundation

struct LabelImageRepositoryImpl: LabelImageRepository { 
    let cachedDataSource: CachedDataSource

    func loadlabeledImageData() -> Observable<[LabelImageEntity]> {
        return cachedDataSource.getAllLabeledImageData()
    }

    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.loadAlbumData(label: label)
    }

    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelEntity]> {
        return cachedDataSource.searchLabelByImage(image: image)
    }
}
