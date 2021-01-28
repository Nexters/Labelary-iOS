//
//  Array+.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/28.
//

import Foundation
import RealmSwift

extension Array {
    func mapNotNull<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        var result: [T] = []

        for item in self {
            let optionalableItem = try transform(item)
            if let item = optionalableItem {
                result.append(item)
            }
        }

        return result
    }
}

extension Sequence {
    func mapNotNull<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        return try self.reduce([T]()) { (result, item) -> [T] in
            let optionalableItem = try transform(item)
            if let nonOptionableItem = optionalableItem {
                return result + [nonOptionableItem]
            }
            return result
        }
    }
}

extension List {
    func mapNotNull<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        var result: [T] = []

        for item in self {
            let optionalableItem = try transform(item)
            if let item = optionalableItem {
                result.append(item)
            }
        }

        return result
    }
}

extension Results {
    func mapNotNull<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        var result: [T] = []

        for item in self {
            let optionalableItem = try transform(item)
            if let item = optionalableItem {
                result.append(item)
            }
        }

        return result
    }
}
