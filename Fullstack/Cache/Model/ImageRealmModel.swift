//
//  ImageRealmModel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation
import RealmSwift

class ImageRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var source: String?

    var neededLabels: [LabelRealmModel] {
        get {
            return labels.map { $0.self }
        }
        set {
            labels.removeAll()
            labels.append(objectsIn: newValue.map {
                LabelRealmModel(value: [$0])
            })
        }
    }
    
    dynamic var labels: List<LabelRealmModel> = List()
    @objc dynamic var isBookmark: Bool = false

    override static func primaryKey() -> String {
        return "id"
    }
    
    
}


extension ImageRealmModel {

    func convertToEntity() -> ImageEntity? {
       // print("ImageRealmModel 확인 \n id \(self.id) : \n source : \(self.source) \n label: \(self.labels)")

        guard !self.id.isEmpty, let source = self.source else {
            return nil
        }

        return ImageEntity(
            source: source,
            id: self.id,
            labels: self.labels.mapNotNull { $0.convertToEntity() }, 
            isBookmark: self.isBookmark,
            isCached: true
        )
    }
}

