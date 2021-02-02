//
//  LabelingRepositoryImpl.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/02.
//

import Foundation

struct LabelingRepositoryImpl: LabelRepository {
    let cachedDataSource: CachedDataSource

    func getAllLabels() -> Observable<[LabelEntity]> {
        return cachedDataSource.getAllLabels()
    }

    func searchLabel(keyword: String) -> Observable<[LabelEntity]> {
        return cachedDataSource.searchLabel(keyword: keyword)
    }

    func getLabel(id: String) -> Observable<LabelEntity?> {
        return cachedDataSource.getLabel(id: id)
    }

    func getRecentSearcheLabels(count: Int?) -> Observable<[LabelEntity]> {
        return cachedDataSource.getRecentSearcheLabels(count: count)
    }

    func getRecentCreatedLabels(count: Int?) -> Observable<[LabelEntity]> {
        return cachedDataSource.getRecentCreatedLabels(count: count)
    }

    func createLabel(name: String, color: ColorSet) -> Observable<LabelEntity> {
        return cachedDataSource.createLabel(name: name, color: color)
    }

    func deleteLabel(label: LabelEntity) -> Observable<String> {
        return cachedDataSource.deleteLabel(label: label)
    }

    func updateLabel(label: LabelEntity) -> Observable<LabelEntity> {
        return cachedDataSource.updateLabel(label: label)
    }
}
