//
//  FullstackApp.swift
//  Fullstack
//
//  Created by 우민지 on 2021/01/16.
////

import SwiftUI
import UIKit
import AvoInspector
import Mixpanel
import RealmSwift

var avo:Avo?
let avoInspector = AvoInspector(apiKey: "PXSDmMdhEjkWGSAyaJAq", env: AvoInspectorEnv.dev)

@main
struct FullstackApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
    
    init() {
        let mixPanelDest = MixpanelDestination()
        Mixpanel.initialize(token: "c176143d8dbfdecf761efc91300def66")
        // ---------------------- Avo --------------------------
        avo = Avo(env: .prod, mixpanelDestination: mixPanelDest )
        avo?.loadApp(deviceId: "\(UIDevice.current.identifierForVendor!.uuidString)")
    }
}

