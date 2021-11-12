//
//  LabelImageRepository.swift
//  Fullstack
//
//  Created by 우민지 on 2021/11/02.
//

import Foundation

protocol LabelImageRepository {
    //  load the image data saved in realm
    func loadlabeledImageData() -> Observable<[LabelImageEntity]>
    func requestNewLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[LabelImageEntity]>

    // load image data list categorized by the LABEL
    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]>
    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelEntity]>
}
