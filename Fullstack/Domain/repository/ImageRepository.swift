//
//  ImageRepository.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

protocol ImageRepository {
    func getAllImages() -> Observable<SearchResult>
    func getUnLabeledImages(filtered: [ImageEntity]) -> Observable<[ImageEntity]>
    func getLabeldImages() -> Observable<SearchResult>

    func getImages(labels: [LabelEntity], pageId: Int) -> Observable<SearchResult>
    func getBookmarkImages() -> Observable<SearchResult>
    func getImage(id: String) -> Observable<ImageEntity>

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity>

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]>
    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]>
    func deleteImages(images: [ImageEntity]) -> Observable<[String]>
}
