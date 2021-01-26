//
//  ImageRepository.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

protocol ImageRepository {
    
    func getAllImages() -> Observable<Array<ImageEntity>>
    func getUnLabeledImages() -> Observable<Array<ImageEntity>>
    func getLabeldImages() -> Observable<Array<ImageEntity>>
    
    func getImages(labels : Array<LabelEntity>) -> Observable<Array<ImageEntity>>
    func getBookmarkImages() -> Observable<Array<ImageEntity>>
    func getImage(id : String) -> Observable<ImageEntity>
    
    func requestLabeling(labels : Array<LabelEntity>, images : Array<ImageEntity>) -> Observable<ImageEntity>
    func removeLabel(label : LabelEntity, images : Array<ImageEntity>) -> Observable<Void>
    func removeImage(image : ImageEntity) -> Observable<Void>
}
