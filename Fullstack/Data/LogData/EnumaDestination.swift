//
//  EnumaDestination.swift
//  Fullstack
//
//  Created by 우민지 on 2022/06/17.
//

import Foundation

// Enuma 서버로 보내기 
// s3://db-c5e7e752e52cde5cc368075ac9f808f2-s3-root-bucket/oregon-prod/1327323773818177/

class EnumaDestination: AvoCustomDestination {
    // apiKey 필요 x
    
    func make(env: AvoEnv, apiKey: String) {
       // send request
        let url = URL(string: "https://")!
        var request = URLRequest(url: url)
        
        
    }
    
    func logEvent(eventName: String, eventProperties: [String : Any]) {
   //     RSClient.sharedInstance()?.track(eventName, properties: eventProperties)
        
    
    }
    
    func setUserProperties(userId: String, userProperties: [String : Any]) {
//        if !userProperties.isEmpty {
//            RSClient.sharedInstance()?.identify(userId, traits: userProperties)
//        }
    }

    func logPage(pageName: String, eventProperties: [String:Any]) {
      //  RSClient.sharedInstance()?.screen(pageName, properties: eventProperties)
    }

    func revenue(amount: Double, eventProperties: [String:Any]) {
        // Rudderstack does not support revenue tracking, you can use logEvent to track revenue manually
    }

    func identify(userId: String) {
      //  RSClient.sharedInstance()?.identify(userId)
    }
    
    func unidentify() {
      //  RSClient.sharedInstance()?.reset()
    }
}

