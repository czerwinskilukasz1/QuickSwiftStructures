//
//  QuickQueue.swift
//  QuickSwiftStructures
//
//  Created by Lukasz Czerwinski on 11/5/15.
//  Copyright © 2015 Lukasz Czerwinski <czerwinskilukasz1@gmail.com>. All rights reserved.
//  Distributed under MIT License

import Foundation

public class QuickQueue<T> {
    
    private var front: QuickNode<T>!
    private var back: QuickNode<T>!
    
    private var _count: UInt32 = 0
    
    // Item count getter.
    var count: UInt32 {
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
        --_count
        let ret = front
        front = front.next
        if front == nil {
            back = nil
        }
        return ret.key
    }
    
    // Check whether the queue is empty.
    // Constant time (O(1)).
    func isEmpty() -> Bool {
        return front == nil
    }
    
    // Remove all elements from the queue.
    // Constant time (O(1)).
    // Note: At some point in the future Swift garbage collector will need up to O(n) to deallocate 
    // unused nodes.
    func removeAll() {
        front = nil
        back = nil
        _count = 0
    }
}
