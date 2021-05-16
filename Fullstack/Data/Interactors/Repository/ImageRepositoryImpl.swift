//
//  ImageRepositoryImpl.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/02.
//

import Foundation

struct ImageRepositoryImpl: ImageRepository {
    let cachedDataSource: CachedDataSource
    
    func getAllImages() -> Observable<[ImageEntity]> {
        return cachedDataSource.getAllImages()
    }
    
    func getUnLabeledImages(filtered: [ImageEntity]) -> Observable<[ImageEntity]> {
        return cachedDataSource.getUnLabeledImages(filtered: filtered)
    }
    
    func getLabeldImages() -> Observable<[ImageEntity]> {
        return cachedDataSource.getLabeldImages()
    }
    
    func getImages(labels: [LabelEntity]) -> Observable<[ImageEntity]> {
        return cachedDataSource.getImages(labels: labels)
    }
    
    func getBookmarkImages() -> Observable<[ImageEntity]> {
        return cachedDataSource.getBookmarkImages()
    }
    
    func getImage(id: String) -> Observable<ImageEntity?> {
        return cachedDataSource.getImage(id: id)
    }
    
    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity> {
        return cachedDataSource.changeBookmark(isActive: isActive, image: image)
    }
    
    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]> {
        return cachedDataSource.requestLabeling(labels: labels, images: images)
    }
    
    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]> {
        return cachedDataSource.deleteLabel(labels: labels, images: images)
    }
    
    func deleteImages(images: [ImageEntity]) -> Observable<[String]> {
        return cachedDataSource.deleteImages(images: images)
    }
    
    func isExistOnRealm(image: ImageEntity) -> Observable<Bool> {
        return cachedDataSource.isExistOnRealm(image: image)
    }
    
    func createImageRealModel(image: ImageEntity) -> Observable<ImageEntity?> {
        return cachedDataSource.createImageRealModel(image: image)
    }
}
