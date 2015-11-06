//
//  QuickBufferTests.swift
//  QuickSwiftStructures
//
//  Created by Lukasz Czerwinski on 11/5/15.
//  Copyright © 2015 Lukasz Czerwinski. All rights reserved.
//

import XCTest
@testable import QuickSwiftStructures

class QuickBufferTests : XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWriteToFull() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let qb = QuickBuffer<Int>(maxLength: 5, bufferingLength: 2)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            qb.pushBack(1)
            qb.pushBack(2)
            qb.pushBack(3)
            qb.pushBack(4)
            qb.pushBack(5)
            qb.pushBack(6)
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            usleep(200*1000)
            XCTAssertEqual(5, qb.count)
            var e = qb.popFront()
            XCTAssertEqual(1, e)
            usleep(200*1000)
            XCTAssertEqual(5, qb.count)
            e = qb.popFront()
            XCTAssertEqual(2, e)
            usleep(200*1000)
            XCTAssertEqual(4, qb.count)
            e = qb.popFront()
            XCTAssertEqual(3, e)
            usleep(200*1000)
            XCTAssertEqual(3, qb.count)
            
            e = qb.popFront()
            XCTAssertEqual(4, e)
            XCTAssertEqual(2, qb.count)
            e = qb.popFront()
            XCTAssertEqual(5, e)
            XCTAssertEqual(1, qb.count)
            e = qb.popFront()
            XCTAssertEqual(6, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
        }
        
    }
    
    
    func testReadFromEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let qb = QuickBuffer<Int>(maxLength: 5, bufferingLength: 0)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            usleep(200*1000)
            qb.pushBack(1)
            usleep(200*1000)
            XCTAssertEqual(0, qb.count)
            qb.pushBack(2)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)

            XCTAssertEqual(0, qb.count)
            qb.pushBack(3)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)

            XCTAssertEqual(0, qb.count)
            qb.pushBack(4)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)

            XCTAssertEqual(0, qb.count)
            qb.pushBack(5)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)

            XCTAssertEqual(0, qb.count)
            qb.pushBack(6)
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            XCTAssertEqual(0, qb.count)
            var e = qb.popFront()
            
            XCTAssertEqual(1, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(2, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(3, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(4, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(5, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(6, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
        }
        
    }
    
    
    func testBuffering() {
        
        let qb = QuickBuffer<Int>(maxLength: 5, bufferingLength: 2)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            usleep(200*1000)
            XCTAssertEqual(0, qb.count)
            qb.pushBack(1)
            usleep(200*1000)
            XCTAssertEqual(1, qb.count)
            qb.pushBack(2)
            XCTAssertEqual(2, qb.count)
            usleep(200*1000)
            XCTAssertEqual(0, qb.count)
            
            qb.pushBack(3)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)
            
            XCTAssertEqual(1, qb.count)
            qb.pushBack(4)
            XCTAssertEqual(2, qb.count)
            usleep(200*1000)
            XCTAssertEqual(0, qb.count)
            
            qb.pushBack(5)
            XCTAssertEqual(1, qb.count)
            usleep(200*1000)
            
            XCTAssertEqual(1, qb.count)
            qb.pushBack(6)
            XCTAssertEqual(2, qb.count)
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            XCTAssertEqual(0, qb.count)
            var e = qb.popFront()
            
            XCTAssertEqual(1, e)
            XCTAssertEqual(1, qb.count)
            XCTAssertFalse(qb.isEmpty())
            e = qb.popFront()
            XCTAssertEqual(2, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(3, e)
            XCTAssertEqual(1, qb.count)
            XCTAssertFalse(qb.isEmpty())
            e = qb.popFront()
            XCTAssertEqual(4, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
            e = qb.popFront()
            
            XCTAssertEqual(5, e)
            XCTAssertEqual(1, qb.count)
            XCTAssertFalse(qb.isEmpty())
            e = qb.popFront()
            XCTAssertEqual(6, e)
            XCTAssertEqual(0, qb.count)
            XCTAssertTrue(qb.isEmpty())
        }
    }
    
    
}
