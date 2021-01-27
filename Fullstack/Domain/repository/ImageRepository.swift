//
//  ImageRepository.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

protocol ImageRepository {
    func getAllImages() -> Observable<[ImageEntity]>
    func getUnLabeledImages() -> Observable<[ImageEntity]>
    func getLabeldImages() -> Observable<[ImageEntity]>

    func getImages(labels: [LabelEntity]) -> Observable<[ImageEntity]>
    func getBookmarkImages() -> Observable<[ImageEntity]>
    func getImage(id: String) -> Observable<ImageEntity>

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<ImageEntity>
    func removeLabel(label: LabelEntity, images: [ImageEntity]) -> Observable<Void>
    func removeImage(image: ImageEntity) -> Observable<Void>
}
