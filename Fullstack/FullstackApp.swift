//
//  FullstackApp.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
////

import Firebase
import SwiftUI

@main
struct FullstackApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() {
        FirebaseApp.configure()
    }
}
