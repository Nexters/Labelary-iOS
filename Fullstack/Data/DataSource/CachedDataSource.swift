//
//  CachedDataSource.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation

protocol CachedDataSource {
    // Image
    func getAllImages() -> Observable<[ImageEntity]>
    func getUnLabeledImages(filtered: [ImageEntity]) -> Observable<[ImageEntity]>
    func getLabeldImages() -> Observable<[ImageEntity]>

    func getImages(labels: [LabelEntity], pageId: Int) -> Observable<[ImageEntity]>
    func getBookmarkImages() -> Observable<[ImageEntity]>
    func getImage(id: String) -> Observable<ImageEntity?>

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity>

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]>
    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]>
    func deleteImages(images: [ImageEntity]) -> Observable<[String]>

    // Label
    func getAllLabels() -> Observable<[LabelEntity]>
    func searchLabel(keyword: String) -> Observable<[LabelEntity]>
    func getLabel(id: String) -> Observable<LabelEntity?>
    func getRecentSearcheLabels(count: Int?) -> Observable<[LabelEntity]>
    func getRecentCreatedLabels(count: Int?) -> Observable<[LabelEntity]>

    func createLabel(name: String, color: ColorSet) -> Observable<LabelEntity>
    func deleteLabel(label: LabelEntity) -> Observable<String>
    func updateLabel(label: LabelEntity) -> Observable<LabelEntity>
}
