//
//  MixpanelDestination.swift
//  Fullstack
//
//  Created by freemjstudio on 6/24/22.
//

import Foundation
import Mixpanel

class MixpanelDestination: AvoCustomDestination {
    func make(env: AvoEnv, apiKey: String) {
        // Learn how to get DATA_PLANE_URL and WRITE_KEY here
        // Note: Initializing your destination in the make method is optional, you can skip it if you've already initialized your destination
        Mixpanel.initialize(token: apiKey)
      
    }
    
    func logEvent(eventName: String, eventProperties: [String : Any]) {
        // TODO: Replace the call below with a call to your destination
           Mixpanel.mainInstance().track(event: eventName, properties: eventProperties as? Properties)
    
    }
    
    func setUserProperties(userId: String, userProperties: [String : Any]) {
        if !userProperties.isEmpty {
               Mixpanel.mainInstance().people.set(properties: userProperties as! Properties)
           }
    }

    func logPage(pageName: String, eventProperties: [String:Any]) {
        Mixpanel.mainInstance().track(event: "Page Viewed", properties: eventProperties as? Properties)
    }

    func revenue(amount: Double, eventProperties: [String:Any]) {
        Mixpanel.mainInstance().people.trackCharge(amount: amount, properties: eventProperties as? Properties)
    }

    func identify(userId: String) {
        Mixpanel.mainInstance().identify(distinctId: userId)
    }
    
    func unidentify() {
        Mixpanel.mainInstance().reset()
    }
}

