//
//  RateLimiter.swift
//  MPRateLimiter
//
//  Created by Matias Piipari on 24/04/2016.
//  Copyright © 2016 Matias Piipari. All rights reserved.
//

import Foundation

public typealias RateLimitedClosure = () throws -> Void

public class RateLimiter {
    
    public init() {}
    
    public func execute(key key:String, rateLimit:NSTimeInterval, closure:RateLimitedClosure) rethrows {
        
        // protect access to nextAllowedExecutionTimes across threads.
        var nextAllowedDateOpt:NSDate? = nil
        dispatch_sync(self.queue) {
           nextAllowedDateOpt = self.nextAllowedExecutionTimes[key]
        }
        
        // if nothing executed before, store next allowed date and execute immediately.
        guard let nextAllowedDate = nextAllowedDateOpt else {
            try self.executeNow(key, rateLimit: rateLimit, closure: closure)
            return
        }
        
        let now = NSDate()
        print("Now: \(now), next: \(nextAllowedDate)")
        
        // if next allowed execution time is in the past, similarly store next allowed date and execute immediately.
        if NSDate().timeIntervalSinceDate(nextAllowedDate) > 0 {
            try self.executeNow(key, rateLimit: rateLimit, closure: closure)
            return
        }
        
        // otherwise sleep until next allowed execution time, set the next allowed date (appending the rate limit to it) and execute.
        NSThread.sleepUntilDate(nextAllowedDate)
        
        let next = nextAllowedDate.dateByAddingTimeInterval(rateLimit)
        
        dispatch_sync(self.queue) {
            self.nextAllowedExecutionTimes[key] = next
        }
        
        try closure()
    }
    
    private var nextAllowedExecutionTimes:[String:NSDate] = [:]
    private let queue = dispatch_queue_create("RateLimiter", DISPATCH_QUEUE_SERIAL)

    private func executeNow(key:String, rateLimit:NSTimeInterval, closure:RateLimitedClosure) rethrows {
        let now = NSDate()
        dispatch_sync(self.queue) {
            self.nextAllowedExecutionTimes[key] = NSDate(timeIntervalSinceNow: rateLimit)
        }
        
        print("Now: \(now), next: \(self.nextAllowedExecutionTimes[key])")
        
        try closure()
    }
}

