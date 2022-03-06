//
//  LabelImageRepository.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Foundation

protocol LabelImageRepository {
    // change label of labelImageEntity
    func changeFromLabelToLabel(images: [ImageEntity], fromLabel: LabelEntity, toLabel: LabelEntity) -> Observable<[LabelImageEntity]>

    //  load the image data saved in realm
    func loadlabeledImageData() -> Observable<[LabelImageEntity]>

    // load image data list categorized by the LABEL
    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]>
    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelImageEntity]>

    // load image data by time
    func loadRecentlyLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]>
    func loadOldLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]>
    func getImages(labels: [LabelEntity]) -> Observable<[LabelImageEntity]>
}
