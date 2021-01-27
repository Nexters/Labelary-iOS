//
//  Usecase.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Combine
import Foundation

protocol Usecase {
    associatedtype Param
    associatedtype Result

    func get(param: Param) -> Observable<Result>
}
