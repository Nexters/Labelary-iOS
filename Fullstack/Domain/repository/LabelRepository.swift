//
//  LabelRepository.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

protocol LabelRepository {
    
    func getAllLabels() -> Observable<Array<LabelEntity>>
    func getLabel(name : String) -> Observable<Array<LabelEntity>>
    func getLabel(id : String) -> Observable<LabelEntity>
    func getRecentSearcheLabels(count : Int?) -> Observable<Array<LabelEntity>>
    func getRecentCreatedLabels(count : Int?) -> Observable<Array<LabelEntity>>
    
    
    func createLabel(name : String, color : ColorSet) -> Observable<LabelEntity>
    func deleteLabel(label : LabelEntity) -> Observable<Void>
    func updateLabel(label : LabelEntity) -> Observable<Void>
}
