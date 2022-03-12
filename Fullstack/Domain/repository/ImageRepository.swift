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

 //   func getImages(labels: [LabelEntity]) -> Observable<[ImageEntity]>
    func getBookmarkImages() -> Observable<[ImageEntity]>
    func getImage(id: String) -> Observable<ImageEntity?>

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity>

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[LabelImageEntity]>
    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]>
 //   func deleteImages(images: [ImageEntity]) -> Observable<[String]>
    func deleteImages(images: [ImageEntity]) -> Observable<[ImageEntity]> 
    func deleteImageFromLabel(images: [ImageEntity]) -> Observable<[LabelImageEntity]>

    func isExistOnRealm(image: ImageEntity) -> Observable<Bool>
    func createImageRealModel(image: ImageEntity) -> Observable<ImageEntity?>
}
