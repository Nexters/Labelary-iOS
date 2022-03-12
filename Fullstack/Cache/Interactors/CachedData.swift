//
//  RealmDataSource.swift
//  Fullstack
//

import Combine
import Foundation
import Photos
import RealmSwift

struct CachedData: CachedDataSource {
    let realm: Realm = try! Realm()

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

    func getAllImages() -> Observable<[ImageEntity]> {
        let realm: Realm = try! Realm()
        let screenShotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        var results: [ImageEntity] = []
        if let album = screenShotAlbum {
            let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)

            for index in 0 ..< assets.count {
                results.append(assets.object(at: index).toEntity())
            }
        }
        // source 가 삭제된 경우 거르기 !!

        return Just(realm.objects(ImageRealmModel.self))
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .map { entities in entities + results.filter { item in !entities.contains(where: { $0.id == item.id }) } }
            .asObservable()
    }

    func getUnLabeledImages() -> Observable<[ImageEntity]> {
        let realm: Realm = try! Realm()
        let screenShotAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil).firstObject
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        var results: [ImageEntity] = []
        let labelImageQuery = realm.objects(LabelImageRealmModel.self)

        if let album = screenShotAlbum {
            let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
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

    // search screenshot
    func getImages(labels: [LabelEntity]) -> Observable<[LabelImageEntity]> {
        let realm: Realm = try! Realm()
        let labelQuery = realm.objects(LabelRealmModel.self).filter { item in labels.contains { $0.id == item.id }}
        let set = Set(labelQuery)

        let query = realm.objects(LabelImageRealmModel.self).filter {
            set.isSubset(of: Set($0.labels))
        }

        return Just(query).asObservable().map { result in result.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getBookmarkImages() -> Observable<[ImageEntity]> {
        let realm: Realm = try! Realm()
        let query: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { $0.isBookmark }
        return Just(query).asObservable()
            .map { results in results.mapNotNull { $0.convertToEntity() }}
            .eraseToAnyPublisher()
    }

    func getImage(id: String) -> Observable<ImageEntity?> {
        let realm: Realm = try! Realm()
        let query: ImageRealmModel? = realm.objects(ImageRealmModel.self)
            .first { $0.id == id }
        return Just(query).asObservable()
            .map { $0?.convertToEntity() }
            .eraseToAnyPublisher()
    }

    func changeBookmark(isActive: Bool, image: ImageEntity) -> Observable<ImageEntity> {
        let realm: Realm = try! Realm()
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

    // 이미지들 라벨을 다른 라벨로 바꾸는 거임
    func changeFromLabelToLabel(images: [ImageEntity], fromLabel: LabelEntity, toLabel: LabelEntity) -> Observable<[LabelImageEntity]> {
        let realm: Realm = try! Realm()
        let toLabelQuery = realm.objects(LabelRealmModel.self).filter { $0.id == toLabel.id }
        var labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { item in images.contains { $0.id == item.image?.id }} // 새로운 data
        try! realm.write {
            for labelImage in labelImageQuery {
                for (index, item) in labelImage.labels.enumerated() {
                    if item.id == fromLabel.id {
                        labelImage.labels.remove(at: index)
                    }
                }

                labelImage.labels.append(objectsIn: toLabelQuery)

                realm.add(labelImage, update: .modified)
            }
        }

        return Just(labelImageQuery).asObservable()
            .map { _ in
                labelImageQuery.mapNotNull { $0.convertToEntity() }
            }.eraseToAnyPublisher()
    }

    func requestLabeling(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[LabelImageEntity]> {
        let realm: Realm = try! Realm()
        var imageQuery = realm.objects(ImageRealmModel.self).filter { item in images.contains { $0.id == item.id }}
        let labelQuery = realm.objects(LabelRealmModel.self).filter { item in labels.contains { $0.id == item.id }}

        var labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { item in images.contains { $0.id == item.image?.id }}

        if imageQuery.count == 0 {
            try! realm.write {
                let needToAddedImages = images.filter { !$0.isCached }
                needToAddedImages.forEach { entity in

                    let model = ImageRealmModel()
                    model.id = entity.id
                    model.source = entity.source
                    model.isBookmark = entity.isBookmark
                    realm.add(model)
                }
            }
        }

        imageQuery = realm.objects(ImageRealmModel.self).filter { item in images.contains { $0.id == item.id }}

        if labelImageQuery.isEmpty {
            try! realm.write {
                for neededimage in imageQuery {
                    let labelImageModel = LabelImageRealmModel()
                    labelImageModel.image = neededimage
                    labelImageModel.labels.append(objectsIn: labelQuery)
                    labelImageModel.createdAt = Date()

                    realm.add(labelImageModel)
                }
            }
        } else {
            try! realm.write {
                for existData in labelImageQuery {
                    existData.labels.append(objectsIn: labelQuery)
                    realm.add(existData)
                }
            }
        }

        // 반환할 쿼리 갱신
        labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { item in images.contains { $0.id == item.image?.id }}

        return
            Just(labelImageQuery).asObservable()
                .map { _ in
                    labelImageQuery.mapNotNull { $0.convertToEntity() }

                }.eraseToAnyPublisher()
    }

    // realmDB 초기화
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]> {
        let realm: Realm = try! Realm()
        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}
        let labelQuery: [LabelRealmModel] = realm.objects(LabelRealmModel.self)
            .filter { item in labels.contains { $0.id == item.id }}
        let labelImageQuery = realm.objects(LabelImageRealmModel.self)
        for labelImage in labelImageQuery {
            for item in labelImage.labels {
                if let index = labelImage.labels.firstIndex(where: { $0.id == item.id }) {
                    labelImage.labels.remove(at: index)
                }
            }
            try! realm.write {
                realm.add(labelImage)
            }
        }
        try! realm.write {
            realm.delete(labelQuery)
        }
        return Just((imageQuery, labelQuery)).asObservable()
            .map { imageQuery, labelQuery in
                imageQuery.forEach { _ in
                    labelQuery.forEach { _ in
                    }
                }
                return imageQuery.mapNotNull { $0.id }
            }.eraseToAnyPublisher()
    }

//    func deleteLabel(labels: [LabelEntity], images: [ImageEntity]) -> Observable<[String]> {
//        let imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
//            .filter { item in images.contains { $0.id == item.id }}
//        let labelQuery: [LabelRealmModel] = realm.objects(LabelRealmModel.self)
//            .filter { item in labels.contains { $0.id == item.id }}
//
//        let labelImageQuery: [LabelImageRealmModel] = realm.objects(LabelImageRealmModel.self) // 여기서 이미지한테서 라벨만 하나 쏙 빼주면 되지 않나 ?????
//
//
//        return Just((imageQuery, labelQuery)).asObservable()
//            .map { imageQuery, labelQuery in
//
//                imageQuery.forEach { image in
//                    labelQuery.forEach { item in
//
//                        if let index = image.labels.firstIndex(where: { $0.id == item.id }) {
//                            image.labels.remove(at: index)
//                        }
//
    ////                        if let index = item.images.firstIndex(where: { $0.id == image.id }) {
    ////                            item.images.remove(at: index)
    ////                        }
//                    }
//                }
//                return imageQuery.mapNotNull { $0.id }
//            }.eraseToAnyPublisher()
//    }

    /*
     func deleteImages(images: [ImageEntity]) -> Observable<[String]> {
         let realm: Realm = try! Realm()
         var imageQuery: [ImageRealmModel] = realm.objects(ImageRealmModel.self)
             .filter { item in images.contains { $0.id == item.id }}

         var labelImageQuery: [LabelImageRealmModel] = realm.objects(LabelImageRealmModel.self)
             .filter { item in images.contains { $0.id == item.image?.id }}

         do {
             try realm.write {
                 if labelImageQuery.count > 0 {
                     realm.delete(labelImageQuery)
                 }

                 for image in imageQuery {
                     image.isAvailable = false
                 }
             }
         } catch let err {
             print(err)
         }

         imageQuery = realm.objects(ImageRealmModel.self)
             .filter { item in images.contains { $0.id == item.id }}

         return Just(imageQuery).asObservable()
             .map { _ in
                 imageQuery.mapNotNull { $0.id }
             }.eraseToAnyPublisher()
     }

     */

    func deleteImages(images: [ImageEntity]) -> Observable<[ImageEntity]> {
        let realm: Realm = try! Realm()

        let labelImageQuery: [LabelImageRealmModel] = realm.objects(LabelImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.image?.id }}

        for img in images {
            let imgQuery: ImageRealmModel? = realm.object(ofType: ImageRealmModel.self, forPrimaryKey: img.id)
            if imgQuery == nil {
                try! realm.write {
                    let model = ImageRealmModel()
                    model.id = img.id
                    model.source = img.source
                    model.isAvailable = false
                    realm.add(model)
                }
            } else {
                try! realm.write {
                    imgQuery!.isAvailable = false
                }
            }
        }

        do {
            try realm.write {
                if labelImageQuery.count > 0 {
                    realm.delete(labelImageQuery)
                }
            }
        } catch let err {
            print(err)
        }

        let imageQuery = realm.objects(ImageRealmModel.self)
            .filter { item in images.contains { $0.id == item.id }}

        return Just(imageQuery).asObservable()
            .map { _ in
                imageQuery.mapNotNull { $0.convertToEntity() }
            }
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

    // LabelImageEntity

    // 라벨링 된 이미지 데이터를 모두 로드 시킨다.
    func getAllLabeledImageData() -> Observable<[LabelImageEntity]> {
        return Just(realm.objects(LabelImageRealmModel.self)).asObservable()
            .map { result in result.mapNotNull { $0.convertToEntity() } }
            .eraseToAnyPublisher()
    }

    func loadAlbumData(label: LabelEntity) -> Observable<[LabelImageEntity]> {
        let labelImageQuery = realm.objects(LabelImageRealmModel.self)

        var query: [LabelImageRealmModel] = []

        for labelImage in labelImageQuery {
            let labels = labelImage.labels
            for data in labels {
                if data.id == label.id {
                    query.append(labelImage)
                    continue
                }
            }
        }

        return Just(query).asObservable().map { results in results.mapNotNull { $0.convertToEntity() }}.eraseToAnyPublisher()
    }

    func searchLabelByImage(image: ImageEntity) -> Observable<[LabelImageEntity]> {
        let labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { $0.image?.id == image.id }

        return Just(labelImageQuery).asObservable().map { results in results.mapNotNull { $0.convertToEntity() }}.eraseToAnyPublisher()
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
//
//    func deleteLabel(label: LabelEntity) -> Observable<String> {
//        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
//        do {
//            try! realm.write {
//                if let object = query {
//                    realm.delete(object)
//                }
//            }
//        } catch {
//            print("\(error.localizedDescription)")
//        }
//
//        return Just(query).asObservable()
//            .tryMap { item in
//                guard let unwrappedItem = item else {
//                    throw DomainError.DoNotFoundEntity
//                }
//                let id = unwrappedItem.id
//                // realm.delete(unwrappedItem)
//                return id
//            }.eraseToAnyPublisher()
//    }

    func deleteImageFromLabel(images: [ImageEntity]) -> Observable<[LabelImageEntity]> {
        let imageQuery = realm.objects(ImageRealmModel.self).filter { item in images.contains { $0.id == item.id }}
        var labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { item in images.contains { $0.id == item.image?.id }}
        try! realm.write {
            realm.delete(labelImageQuery)
            realm.delete(imageQuery)
        }
        labelImageQuery = realm.objects(LabelImageRealmModel.self).filter { item in images.contains { $0.id == item.image?.id }}
        return Just(labelImageQuery.self).asObservable()
            .map { _ in
                labelImageQuery.mapNotNull { $0.convertToEntity() }
            }.eraseToAnyPublisher()
    }

    func deleteLabel(label: LabelEntity) -> Observable<String> {
        let query = realm.object(ofType: LabelRealmModel.self, forPrimaryKey: label.id)
        let id = label.id
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
                // let id = unwrappedItem.id
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

    func loadRecentlyLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]> {
        let labelImageQuery = realm.objects(LabelImageRealmModel.self).sorted(byKeyPath: "createdAt", ascending: true).filter { item in labelImages.contains { $0.id == item.id }}

        return Just(labelImageQuery).asObservable()
            .map { _ in
                labelImageQuery.mapNotNull { $0.convertToEntity() }
            }.eraseToAnyPublisher()
    }

    func loadOldLabeledImage(labelImages: [LabelImageEntity]) -> Observable<[LabelImageEntity]> {
        let labelImageQuery = realm.objects(LabelImageRealmModel.self).sorted(byKeyPath: "createdAt", ascending: false).filter { item in labelImages.contains { $0.id == item.id }}

        return Just(labelImageQuery).asObservable()
            .map { _ in
                labelImageQuery.mapNotNull { $0.convertToEntity() }
            }.eraseToAnyPublisher()
    }
}
