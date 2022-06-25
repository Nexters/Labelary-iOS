//
//  Request.swift
//  Fullstack
//
//  Created by 우민지 on 2022/04/19.
//

import Foundation

// RudderStack self hosting 코드 
func urlRequest() {
    var semaphore = DispatchSemaphore(value: 0)
    var request = URLRequest(url: URL(string: "https://enumaminjhpy.dataplane.rudderstack.com")!,timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
        }
        print(String(data: data, encoding: .utf8)!)
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
}



