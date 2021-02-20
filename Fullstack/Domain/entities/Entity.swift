//
//  Entity.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation

protocol Entity: Equatable, Identifiable, Hashable {
    var id: String
    { get }
}

extension Entity {
    var hashValue: Int { self.id.hash }
}

extension Entity {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
