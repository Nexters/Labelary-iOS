//
//  LoadSearchLabelData.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Combine
import Foundation

struct LoadSearchLabelData: Usecase {
    typealias Param = Void
    typealias Result = ResultData
    
    let labelRepository: LabelRepository
    
    func get(param: Param) -> Observable<Result> {
        return Publishers.Zip(
            labelRepository.getRecentSearcheLabels(count: 10),
            labelRepository.getRecentCreatedLabels(count: nil)
        ).map { ResultData(recentlySearchedLabels: $0, recentlyAddedLabels: $1) }
            .eraseToAnyPublisher()
    }
    
    struct ResultData {
        let recentlySearchedLabels: [LabelEntity]
        let recentlyAddedLabels: [LabelEntity]
    }
}
