//
//  CachedDataSource.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation

protocol CachedDataSource {
    // ImageLabel
    func getAllLabeledImageData() -> Observable<[LabelImageEntity]>
    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]> // 이게 get image by label
    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelEntity]>

    // Image
    func getAllImages() -> Observable<[ImageEntity]>
    func getUnLabeledImages() -> Observable<[ImageEntity]>
    func getLabeldImages() -> Observable<[ImageEntity]>

//    func getImages(labels: [LabelEntity]) -> Observable<[ImageEntity]>
    func getBookmarkImages() -> Observable<[ImageEntity]>
    func getImage(id: String) -> Observable<ImageEntity?>

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity>

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[LabelImageEntity]>

    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]>
    func deleteImages(images: [ImageEntity]) -> Observable<[String]>

    func isExistOnRealm(image: ImageEntity) -> Observable<Bool>
    func createImageRealModel(image: ImageEntity) -> Observable<ImageEntity?>

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
