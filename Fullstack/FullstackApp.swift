//
//  FullstackApp.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
//

import SwiftUI
import Firebase

@main
struct FullstackApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() {
        FirebaseApp.configure()
        Analytics.logEvent("hot_or_cold_switch",parameters: nil)
    }
}
