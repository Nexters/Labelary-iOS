//
//  RudderDestination.swift
//  Fullstack
//
//  Created by 우민지 on 2022/04/19.
//

import Foundation
import Rudder

let DATA_PLANE_URL = "https://enumaminjhpy.dataplane.rudderstack.com"
let WRITE_KEY = "27f1RPyf43JsLVZ5FGGAphtlSJ3"

class RudderDestination: AvoCustomDestination {
    func make(env: AvoEnv, apiKey: String) {
        // Learn how to get DATA_PLANE_URL and WRITE_KEY here
       
        let builder: RSConfigBuilder = RSConfigBuilder().withDataPlaneUrl(DATA_PLANE_URL)
        RSClient.getInstance(WRITE_KEY, config: builder.build())
        RSClient.sharedInstance()?.optOut(false)
    }
    
    func logEvent(eventName: String, eventProperties: [String : Any]) {
        RSClient.sharedInstance()?.track(eventName, properties: eventProperties)
        
        print("eventName:", eventName)
        print("eventProperties: ", eventProperties.keys)
    
    }
    
    func setUserProperties(userId: String, userProperties: [String : Any]) {
        if !userProperties.isEmpty {
            RSClient.sharedInstance()?.identify(userId, traits: userProperties)
        }
    }

    func logPage(pageName: String, eventProperties: [String:Any]) {
        RSClient.sharedInstance()?.screen(pageName, properties: eventProperties)
    }

    func revenue(amount: Double, eventProperties: [String:Any]) {
        // Rudderstack does not support revenue tracking, you can use logEvent to track revenue manually
    }

    func identify(userId: String) {
        RSClient.sharedInstance()?.identify(userId)
    }
    
    func unidentify() {
        RSClient.sharedInstance()?.reset()
    }
}
