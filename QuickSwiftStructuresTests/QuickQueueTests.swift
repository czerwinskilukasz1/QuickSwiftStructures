//
//  QuickQueueTests.swift
//  QuickSwiftStructures
//
//  Created by Lukasz Czerwinski on 11/5/15.
//  Copyright © 2015 Lukasz Czerwinski. All rights reserved.
//  Distributed under MIT License

import XCTest
@testable import QuickSwiftStructures

class QuickQueueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let q = QuickQueue<Int>()
        q.pushBack(5)
        XCTAssertFalse(q.isEmpty())
        XCTAssertEqual(1, q.count)
        XCTAssertFalse(q.isEmpty())
        XCTAssertEqual(5, q.top()!)
        q.popFront()
        XCTAssertTrue(q.isEmpty())
        XCTAssertEqual(0, q.count)
        XCTAssertTrue(q.isEmpty())
        XCTAssertNil(q.top())
    }
    
    func testTop() {
        let q = QuickQueue<Int>()
        q.pushBack(8)
        XCTAssertEqual(8, q.top())
        XCTAssertEqual(8, q.top())
        q.pushBack(9)
        XCTAssertEqual(8, q.top())
        q.pushBack(3)
        XCTAssertEqual(8, q.top())
    }
    
    func testCount() {
        let q = QuickQueue<Int>()
        XCTAssertEqual(0, q.count)
        q.pushBack(8)
        XCTAssertEqual(1, q.count)
        q.pushBack(9)
        XCTAssertEqual(2, q.count)
        q.pushBack(3)
        XCTAssertEqual(3, q.count)
        q.popFront()
        XCTAssertEqual(2, q.count)
        q.popFront()
        XCTAssertEqual(1, q.count)
        q.popFront()
        XCTAssertEqual(0, q.count)
        q.popFront()
        XCTAssertEqual(0, q.count)
    }
    
    func testOrderFIFO() {
        let q = QuickQueue<Int>()
        q.pushBack(8)
        XCTAssertEqual(8, q.top())
        q.pushBack(9)
        q.pushBack(3)
        XCTAssertEqual(8, q.popFront())
        XCTAssertEqual(9, q.popFront())
        q.pushBack(5)
        q.pushBack(2)
        XCTAssertEqual(3, q.popFront())
        XCTAssertEqual(5, q.popFront())
        XCTAssertEqual(2, q.popFront())
        XCTAssertEqual(nil, q.popFront())
    }
    
    func testPushPop() {
        let q = QuickQueue<Int>()
        q.pushBack(8)
        var e = q.popFront()
        XCTAssertNotNil(e)
        q.pushBack(7)
        e = q.popFront()
        XCTAssertNotNil(e)
    }
    
    func testRemoveAll() {
        let q = QuickQueue<Int>()
        q.pushBack(1)
        q.pushBack(2)
        q.pushBack(3)
        q.pushBack(4)
        q.pushBack(5)
        q.removeAll()
        XCTAssertNil(q.top())
        XCTAssertEqual(0, q.count)
        q.pushBack(3)
        XCTAssertNotNil(q.top())
        XCTAssertEqual(1, q.count)
        q.pushBack(6)
        XCTAssertNotNil(q.top())
        XCTAssertEqual(2, q.count)
    }
}
