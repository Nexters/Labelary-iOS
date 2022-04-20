//
//  PostHogDestination.swift
//  Fullstack
//
//  Created by 우민지 on 2022/04/20.
//

import Foundation


class PostHogDestination: AvoCustomDestination {
    func make(env: AvoEnv, apiKey: String) {
        
    }
    
    func logEvent(eventName: String, eventProperties: [String : Any]) {
        
    }
    
    func setUserProperties(userId: String, userProperties: [String : Any]) {
        if !userProperties.isEmpty {
            
        }
    }

    func logPage(pageName: String, eventProperties: [String:Any]) {
        
    }

    func revenue(amount: Double, eventProperties: [String:Any]) {
        // Rudderstack does not support revenue tracking, you can use logEvent to track revenue manually
    }

    func identify(userId: String) {
     
    }
    
    func unidentify() {
        
    }
}
