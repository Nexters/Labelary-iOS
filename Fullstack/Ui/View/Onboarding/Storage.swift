//
//  Storage.swift
//  Fullstack
//
//  Created by 우민지 on 2022/01/20.
//

import Foundation


class Storage {
    static func isFirstTime() -> Bool {
        if UserDefaults.standard.object(forKey: "isFirstTime") == nil {
            UserDefaults.standard.set("No", forKey: "isFirstTime")
            print("first time to launch")
            return true
        } else {
            print("This is Not the first time to launch")
            return false
        }
    }
}
