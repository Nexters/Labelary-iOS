//
//  LabelImageRepositoryImpl.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Foundation

struct LabelImageRepositoryImpl: LabelImageRepository {
    let cachedDataSource: CachedDataSource

    func changeFromLabelToLabel(images: [ImageEntity], fromLabel: LabelEntity, toLabel: LabelEntity) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.changeFromLabelToLabel(images: images, fromLabel: fromLabel, toLabel: toLabel)
    }

    func loadlabeledImageData() -> Observable<[LabelImageEntity]> {
        return cachedDataSource.getAllLabeledImageData()
    }

    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.loadAlbumData(label: label)
    }

    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.searchLabelByImage(image: image)
    }

    func loadOldLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.loadRecentlyLabeledImage(labelImages: labelImages)
    }

    func loadRecentlyLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.loadOldLabeledImage(labelImages: labelImages)
    }

    func getImages(labels: [LabelEntity]) -> Observable<[LabelImageEntity]> {
        return cachedDataSource.getImages(labels: labels)
    }
}
