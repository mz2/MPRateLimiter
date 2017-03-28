//
//  RateLimiter.swift
//  MPRateLimiter
//
//  Created by Matias Piipari on 24/04/2016.
//  Copyright © 2016 Matias Piipari. All rights reserved.
//

import Foundation

public typealias RateLimitedClosure = () throws -> Void

open class RateLimiter {
    
    public init() {}
    
    open func execute(key:String, rateLimit:TimeInterval, closure:RateLimitedClosure) rethrows {
        
        // protect access to nextAllowedExecutionTimes across threads.
        var nextAllowedDateOpt:Date? = nil
        self.queue.sync {
           nextAllowedDateOpt = self.nextAllowedExecutionTimes[key]
        }
        
        // if nothing executed before, store next allowed date and execute immediately.
        guard let nextAllowedDate = nextAllowedDateOpt else {
            try self.executeNow(key: key, rateLimit: rateLimit, closure: closure)
            return
        }
        
        let now = Date()
        print("Now: \(now), next: \(nextAllowedDate)")
        
        // if next allowed execution time is in the past, similarly store next allowed date and execute immediately.
        if Date().timeIntervalSince(nextAllowedDate) > 0 {
            try self.executeNow(key: key, rateLimit: rateLimit, closure: closure)
            return
        }
        
        // otherwise sleep until next allowed execution time, set the next allowed date (appending the rate limit to it) and execute.
        Thread.sleep(until: nextAllowedDate)
        
        let next = nextAllowedDate.addingTimeInterval(rateLimit)
        
        self.queue.sync {
            self.nextAllowedExecutionTimes[key] = next
        }
        
        try closure()
    }
    
    fileprivate var nextAllowedExecutionTimes:[String:Date] = [:]
    fileprivate let queue = DispatchQueue(label: "RateLimiter", attributes: [])

    fileprivate func executeNow(key:String, rateLimit:TimeInterval, closure:RateLimitedClosure) rethrows {
        let now = Date()
        self.queue.sync {
            self.nextAllowedExecutionTimes[key] = Date(timeIntervalSinceNow: rateLimit)
        }
        
        print("Now: \(now), next: \(self.nextAllowedExecutionTimes[key])")
        
        try closure()
    }
}

