//
//  DomainError.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/28.
//

import Foundation

enum DomainError: Error {
    case DoNotFoundEntity
    case DoNotCreatedEntity
    case ConvertError
}
