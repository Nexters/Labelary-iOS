//
//  DeleteImages.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation

/*
 struct DeleteImages: Usecase {
     typealias Param = [ImageEntity]
     typealias Result = [String]

     let imageRepository: ImageRepository

     func get(param: Param) -> Observable<Result> {

         return Just(param)
             .map{_ in []}
             .receive(on: DispatchQueue.global())
             .flatMap { _ in imageRepository.deleteImages(images: param) }
             .receive(on: DispatchQueue.main)
             .asObservable()
             .eraseToAnyPublisher()
     }
 //    func get(param: [ImageEntity]) -> Observable<[String]> {
 //
 //        return imageRepository.deleteImages(images: param)
 //    }
 }
 */

struct DeleteImages: Usecase {
    typealias Param = [ImageEntity]
    typealias Result = [ImageEntity]

    let imageRepository: ImageRepository

    func get(param: Param) -> Observable<Result> {
        return imageRepository.deleteImages(images: param)
            .asObservable()
            .eraseToAnyPublisher()
    }
}
