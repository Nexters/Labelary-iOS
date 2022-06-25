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


var avo:Avo?
let avoInspector = AvoInspector(apiKey: "PXSDmMdhEjkWGSAyaJAq", env: AvoInspectorEnv.dev)

@main
struct FullstackApp: App {
    let mixPanelDest = MixpanelDestination()
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() {
   
        Mixpanel.initialize(token: "c176143d8dbfdecf761efc91300def66")
        // ---------------------- Avo --------------------------
        avo = Avo(env: .dev, mixpanelDestination: mixPanelDest )
        avo?.loadApp(deviceId: "\(UIDevice.current.identifierForVendor!.uuidString)")
    }
}

