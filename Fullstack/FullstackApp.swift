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


let configuration = PHGPostHogConfiguration(apiKey: "phc_vJsSkb5CwpU1ODV2qtE36IhKUqrNErQaXPhXirRtKT2", host: "https://app.posthog.com")
let posthog = PHGPostHog.shared()

var avo:Avo?
let avoInspector = AvoInspector(apiKey: "PXSDmMdhEjkWGSAyaJAq", env: AvoInspectorEnv.dev)

@main
struct FullstackApp: App {
    let DATA_PLANE_URL = URL(string: "https://enumaminjhpy.dataplane.rudderstack.com")!
    let WRITE_KEY = "27f1RPyf43JsLVZ5FGGAphtlSJ3"
    let rudderStackDest = RudderDestination()
    let postHogDest = PostHogDestination()
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }

    init() {
        //-------------------- RudderStack -----------------------
//        let builder: RSConfigBuilder = RSConfigBuilder().withDataPlaneURL(DATA_PLANE_URL)
//        RSClient.getInstance(WRITE_KEY, config: builder.build()) // RSClient automatically track the events
        
        // -------------------- PostHog -----------------------
//        configuration.captureApplicationLifecycleEvents = true;
//     //   configuration.recordScreenViews = true;
//
//        PHGPostHog.setup(with: configuration)
//        let posthog = PHGPostHog.shared()

        // ---------------------- Avo --------------------------
        avo = Avo(env: .dev, postHogDestination: postHogDest, rudderStackDestination: rudderStackDest)
        avo?.loadApp(uuid: "\(UIDevice.current.identifierForVendor!.uuidString)")
      
    }
}

