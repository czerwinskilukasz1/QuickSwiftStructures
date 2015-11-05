//
//  QuickQueue.swift
//  QuickSwiftStructures
//
//  Created by Lukasz Czerwinski on 11/5/15.
//  Copyright © 2015 Lukasz Czerwinski <czerwinskilukasz1@gmail.com>. All rights reserved.
//

import Foundation

public class QuickQueue<T> {
    
    private var front: QuickNode<T>!
    private var back: QuickNode<T>!
    
    private var _count = 0
    
    // Item count getter.
    var count: Int {
        return _count
    }
    
    
    // Adds an object at the end.
    // Constant time (O(1)).
    func pushBack(key: T) {
        if back == nil {
            back = QuickNode<T>(key: key)
            front = back
        } else {
            back.next = QuickNode<T>(key: key)
            back = back.next
        }
        
        ++_count
    }
    
    
    // Returns the front most item or nil if queue was empty.
    // Constant time (O(1)).
    func top() -> T? {
        return front?.key
    }
    
    
    // Pop and return an item from the front (returns nil if queue was empty).
    // Constant time (O(1)).
    func popFront() -> T? {
        if isEmpty() {
            return nil
        }
        
        let ret = front
        front = front.next
        return ret.key
    }
    
    
    // Check whether the queue is empty.
    // Constant time (O(1)).
    func isEmpty() -> Bool {
        return front == nil
    }
}
