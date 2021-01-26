//
//  SearchLabel.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/26.
//

import Foundation
import Combine

struct SearchLabel : Usecase {
 
    typealias Param = String
    typealias Result = Array<LabelEntity>
    
    let labelRepository : LabelRepository
    
    func get(param : Param) -> Observable<Result> {
        return labelRepository.getLabel(name: param)
    }
}
