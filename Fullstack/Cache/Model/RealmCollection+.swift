//
//  RealmCollection+.swift
//  Fullstack
//
//  Created by 우민지 on 2021/07/21.
//

import Foundation
import RealmSwift

extension RealmCollection
{
    func toArray<T>() -> [T]
    {
        return self.compactMap{$0 as? T}
    }
}
