//
//  MPRateLimiterTests.swift
//  MPRateLimiterTests
//
//  Created by Matias Piipari on 24/04/2016.
//  Copyright © 2016 Matias Piipari. All rights reserved.
//

import XCTest
@testable import MPRateLimiter

class MPRateLimiterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWithinThrottlingLimit() {
        let rateLimiter = RateLimiter()
        
        let start = NSDate()
        rateLimiter.execute(key:"foo", rateLimit: 1) {
        }
        
        rateLimiter.execute(key:"foo", rateLimit: 1) {
        }
        
        let after = NSDate()
        
        let timeIntervalSinceStart = after.timeIntervalSinceDate(start)
        XCTAssert(timeIntervalSinceStart >= 1, "Unexpected time interval since start: \(timeIntervalSinceStart)")
    }
    
    func testAboveThrottlingLimit() {
        let rateLimiter = RateLimiter()
        
        let start = NSDate()
        rateLimiter.execute(key:"foo", rateLimit: 1) {
        }
        
        NSThread.sleepForTimeInterval(3.0)
        
        rateLimiter.execute(key:"foo", rateLimit: 1) {
        }
        
        let after = NSDate()
        
        let timeIntervalSinceStart = after.timeIntervalSinceDate(start)
        XCTAssert(timeIntervalSinceStart >= 3.0, "Unexpected time interval since start: \(timeIntervalSinceStart)")
        
        // the time taken should not be much more than 3.0 as the throttling limit has not actually been hit in this case at all.
        XCTAssert(timeIntervalSinceStart <= 3.1, "Unexpected time interval since start: \(timeIntervalSinceStart)")
    }
}
