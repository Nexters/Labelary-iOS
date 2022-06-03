//
//  FullstackApp.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
////

import SwiftUI
import UIKit
import PostHog
import Rudder
import AvoInspector


var avo:Avo?
let avoInspector = AvoInspector(apiKey: "PXSDmMdhEjkWGSAyaJAq", env: AvoInspectorEnv.dev)

@main
struct FullstackApp: App {
    let rudderStackDest = RudderDestination()
    
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() {
        // ---------------------- Avo --------------------------
        avo = Avo(env: .prod, rudderStackDestination: rudderStackDest)
        avo?.loadApp(uuid: "\(UIDevice.current.identifierForVendor!.uuidString)")
    }
}

