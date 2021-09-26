//
//  RealmDataSource.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Combine
import Foundation
import Photos
import RealmSwift

struct CachedData: CachedDataSource {
    let realm: Realm = try! Realm()

    func getAllImages() -> Observable<[ImageEntity]> {
        let screenShotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject
        var results: [ImageEntity] = []
        if let album = screenShotAlbum {
            let assets = PHAsset.fetchAssets(in: album, options: nil)
            for index in 0 ..< assets.count {
                results.append(assets.object(at: index).toEntity())
            }
        }

        return Just(realm.objects(ImageRealmModel.self))
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .map { entities in entities + results.filter { item in !entities.contains(where: { $0.id == item.id }) } }
            .asObservable()
    }

    func getUnLabeledImages() -> Observable<[ImageEntity]> {
        let screenShotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject
        var results: [ImageEntity] = []

        if let album = screenShotAlbum {
            let assets = PHAsset.fetchAssets(in: album, options: nil)
            for index in 0 ..< assets.count {
                results.append(assets.object(at: index).toEntity())
            }
        }

        return Just(realm.objects(ImageRealmModel.self))
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .map { entities in results.filter { item in !entities.contains(where: { $0.id == item.id }) } }
            .asObservable()
    }

    func getLabeldImages() -> Observable<[ImageEntity]> {
        return Just(realm.objects(ImageRealmModel.self)).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getImages(labels: [LabelEntity]) -> Observable<[ImageEntity]> {
        let query: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in item.labels.contains { label in labels.contains { $0.id == label.id } } }
        return Just(query).asObservable()
            .map { result in result.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getBookmarkImages() -> Observable<[ImageEntity]> {
        let query: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { $0.isBookmark }
        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getImage(id: String) -> Observable<ImageEntity?> {
        let query: ImageRealmModel? = realm.objects(ImageRealmModel.self)
            .first { $0.id == id }
        return Just(query).asObservable()
            .map { $0?.convertToEntity() }
            .eraseToAnyPublisher()
    }

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity> {
        do {
            try realm.write {
                let check: ImageRealmModel? = realm.objects(ImageRealmModel.self)
                    .first { $0.id == image.id }
                if check == nil {
                    let model = ImageRealmModel()
                    model.id = image.id
                    model.source = image.source
                    model.isBookmark = isActive
                    realm.add(model)
                } else {
                    check!.isBookmark = isActive
                }
            }
        } catch {}

        let query: ImageRealmModel? = realm.objects(ImageRealmModel.self)
            .first { $0.id == image.id }

        return Just(query).asObservable()
            .tryMap {
                guard let entity = $0?.convertToEntity() else {
                    throw DomainError.DoNotFoundEntity
                }
                return entity
            }
            .eraseToAnyPublisher()
    }

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]> {
        let imageQuery = realm.objects(ImageRealmModel.self).filter { item in images.contains { $0.id == item.id }}
        let labelQuery = realm.objects(LabelRealmModel.self).filter { item in labels.contains { $0.id == item.id }}

        try! realm.write {
            let needToAddedImages = images.filter { !$0.isCached }

            labelQuery.forEach { entity in
                entity.images.append(objectsIn: imageQuery)
            }

            needToAddedImages.forEach { entity in

                let model = ImageRealmModel()

                model.source = entity.source
                model.isBookmark = entity.isBookmark
                model.labels.append(objectsIn: labelQuery)

                realm.add(model)
            }
        }

        return
            Just((imageQuery, labelQuery)).asObservable()
                .map { imageQuery, labelQuery in
                    imageQuery.forEach {
                        let neeToAddLabels: [LabelRealmModel] = labelQuery.map {
                            $0
                        }
                        .applying($0.labels.difference(from: labelQuery)) ?? []
                        $0.labels.append(objectsIn: neeToAddLabels)
                    }

                    labelQuery.forEach {
                        let neeToAddImages: [ImageRealmModel] = imageQuery.map {
                            $0
                        }
                        .applying($0.images.difference(from: imageQuery)) ?? []
                        $0.images.append(objectsIn: neeToAddImages)
                    }
                    return imageQuery.mapNotNull { $0.convertToEntity() }
                }.eraseToAnyPublisher()
    }

    /*
     func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[ImageEntity]> {
         do {
             try realm.write {
                 let needToAddedImages = images.filter { !$0.isCached }

                 needToAddedImages.forEach { entity in

                     let model = ImageRealmModel()
                     model.source = entity.source
                     model.isBookmark = entity.isBookmark

                     realm.add(model)

                 }
             }
         } catch let error as NSError {
             fatalError("realm error: \(error)")
         }

         return
             Just((realm.objects(ImageRealmModel.self).filter { item in images.contains { $0.id == item.id }}, realm.objects(LabelRealmModel.self).filter { item in labels.contains { $0.id == item.id }})).asObservable()
                 .map { imageQuery, labelQuery in
                     imageQuery.forEach {
                         let neeToAddLabels: [LabelRealmModel] = labelQuery.map {
                             $0
                         }
                         .applying($0.labels.difference(from: labelQuery)) ?? []

                         $0.labels.append(objectsIn: neeToAddLabels)
                     }

                     labelQuery.forEach {
                         let neeToAddImages: [ImageRealmModel] = imageQuery.map {
                             $0
                         }
                         .applying($0.images.difference(from: imageQuery)) ?? []
                         $0.images.append(objectsIn: neeToAddImages)
                     }
                     return imageQuery.mapNotNull { $0.convertToEntity() }
                 }.eraseToAnyPublisher()
     }
     */

    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]> {
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}
        let labelQuery: [LabelRealmModel] = realm.objects(LabelRealmModel.self)
            .filter { item in labels.contains { $0.id == item.id }}
        return Just((imageQuery, labelQuery)).asObservable()
            .map { imageQuery, labelQuery in
                imageQuery.forEach { image in
                    labelQuery.forEach { item in
                        if let index = image.labels.firstIndex(where: { $0.id == item.id }) {
                            image.labels.remove(at: index)
                        }

                        if let index = item.images.firstIndex(where: { $0.id == image.id }) {
                            item.images.remove(at: index)
                        }
                    }
                }
                return imageQuery.mapNotNull { $0.id }
            }.eraseToAnyPublisher()
    }

    func deleteImages(images: [ImageEntity]) -> Observable<[String]> {
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}

        var ids = imageQuery.map { $0.id }
        do {
            try realm.write {
                realm.delete(imageQuery)
            }
        } catch {
            ids = []
        }

        return Just(ids)
            .asObservable()
            .eraseToAnyPublisher()
    }

    func isExistOnRealm(image: ImageEntity) -> Observable<Bool> {
        let imageQuery: ImageRealmModel? = realm.object(ofType: ImageRealmModel.self, forPrimaryKey: image.id)

        return Just(imageQuery).asObservable()
            .map { imageQuery in
                imageQuery != nil
            }.eraseToAnyPublisher()
    }

    func createImageRealModel(image: ImageEntity) -> Observable<ImageEntity?> {
        let model = realm.create(ImageRealmModel.self)
        model.source = image.source
        model.isBookmark = image.isBookmark

        return Just(model).asObservable()
            .map { $0.convertToEntity() }
            .eraseToAnyPublisher()
    }

    // Label
    func getAllLabels() -> Observable<[LabelEntity]> {
        return Just(realm.objects(LabelRealmModel.self)).asObservable()
            .map { results in
                results.mapNotNull { $0.convertToEntity() }
            }
            .eraseToAnyPublisher()
    }

    func searchLabel(keyword: String) -> Observable<[LabelEntity]> {
        let query = realm.objects(LabelRealmModel.self)
            .filter { item in item.name.contains(keyword) }
        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getLabel(id: String) -> Observable<LabelEntity?> {
        let query = realm.objects(LabelRealmModel.self)
            .first { $0.id == id }
        return Just(query).asObservable()
            .map { $0?.convertToEntity() }
            .eraseToAnyPublisher()
    }

    func getRecentSearcheLabels(count: Int?) -> Observable<[LabelEntity]> {
        guard let realCount = count else {
            let query = realm.objects(LabelRealmModel.self)
                .sorted(by: { lhs, rhs in lhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 > rhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 })
            return Just(query).asObservable()
                .map { results in results.mapNotNull { $0.convertToEntity() } }
                .eraseToAnyPublisher()
        }

        let query = realm.objects(LabelRealmModel.self)
            .sorted(by: { lhs, rhs in lhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 > rhs.lastSearchedAt?.timeIntervalSince1970 ?? 0 })
            .prefix(realCount)

        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func getRecentCreatedLabels(count: Int?) -> Observable<[LabelEntity]> {
        guard let realCount = count else {
            let query = realm.objects(LabelRealmModel.self)
                .sorted(by: { lhs, rhs in lhs.createdAt?.timeIntervalSince1970 ?? 0 > rhs.createdAt?.timeIntervalSince1970 ?? 0 })
            return Just(query).asObservable()
                .map { results in results.mapNotNull { $0.convertToEntity() } }
                .eraseToAnyPublisher()
        }

        let query = realm.objects(LabelRealmModel.self)
            .sorted(by: { lhs, rhs in lhs.createdAt?.timeIntervalSince1970 ?? 0 > rhs.createdAt?.timeIntervalSince1970 ?? 0 })
            .prefix(realCount)

        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func createLabel(name: String, color: ColorSet) -> Observable<LabelEntity> {
        var id = ""

        do {
            try realm.write {
                let needToAddModel = LabelRealmModel()
                id = needToAddModel.id
                needToAddModel.name = name
                needToAddModel.color = color.rawValue
                needToAddModel.createdAt = Date()
                realm.add(needToAddModel)
                print("needToAddModel:", needToAddModel)
            }
        } catch let error as NSError {
            fatalError("Error opening realm : \(error)")
        }
        return Just(realm.objects(LabelRealmModel.self).first(where: { $0.id == id })).asObservable()
            .tryMap { item in
                guard let entity = item!.convertToEntity() else {
                    throw DomainError.DoNotFoundEntity
                }

                return entity
            }.eraseToAnyPublisher()
    }

//    func deleteLabel(label: LabelEntity) -> Observable<String> {
//        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
//        return Just(query).asObservable()
//            .tryMap { item in
//                guard let unwrappedItem = item else {
//                    throw DomainError.DoNotFoundEntity
//                }
//                let id = unwrappedItem.id
//                realm.delete(unwrappedItem)
//                return id
//            }.eraseToAnyPublisher()
//    }
//

    func deleteLabel(label: LabelEntity) -> Observable<String> {
        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
        do {
            try! realm.write {
                if let object = query {
                    realm.delete(object)
                }
            }
        } catch {
            print("\(error.localizedDescription)")
        }

        return Just(query).asObservable()
            .tryMap { item in
                guard let unwrappedItem = item else {
                    throw DomainError.DoNotFoundEntity
                }
                let id = unwrappedItem.id
                // realm.delete(unwrappedItem)
                return id
            }.eraseToAnyPublisher()
    }

    func updateLabel(label: LabelEntity) -> Observable<LabelEntity> {
        if let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id) {
            try! realm.write {
                query.color = label.color.rawValue
                query.name = label.name
                realm.add(query, update: .modified)
            }

        } else {
            print("object가 없습니다!")
        }

        return Just(realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)).asObservable()
            .tryMap { item in
                guard let unwrappedItem = item else {
                    throw DomainError.DoNotFoundEntity
                }

                guard let entity = unwrappedItem.convertToEntity() else {
                    throw DomainError.ConvertError
                }
                return entity
            }.eraseToAnyPublisher()
    }
}
