//
//  Usecase.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation
import Combine

protocol Usecase {
    
    associatedtype Param
    associatedtype Result
    
    func get(param : Param) -> Observable<Result>

}
