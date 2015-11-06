//
//  DataBuffer.swift
//
//
//
//  Created by Lukasz Czerwinski on 11/5/15.
//

//  This library implements a buffer (FIFO queue) with conditional variables for ONE writer and ONE reader (wait if the buffer is empty or not full enough - buffering output).
// The buffer has maximum length and "buffering limit".
// When the buffer is full, writer waits on cond.
// When the buffer has no elements, or it had no elements and still has less than bufferingLength elements, reader needs to wait on cond.
// Otherwise it works as a regular FIFO queue.

//
import Foundation

class QuickBuffer<T> {
    
    // Lock for the queue operations
    private let lock = NSLock()
    
    let maxLength: UInt32
    let bufferingLength: UInt32
    private let q = QuickQueue<T>()
    private var status: QuickBufferStatus
    
    private let waitForSpace = NSCondition()
    private let waitForData = NSCondition()
    
    private var writerWaiting = false
    private var readerWaiting = false
    
    // @param maxLength - length of the buffer (needs to be greater than 0)
    // @param bufferingLength - if readers are waiting for a buffer to fill (they had emptied the buffer), there needs to be at least bufferingLength items there to wake them up
    init(maxLength: UInt32, bufferingLength: UInt32) {
        assert(maxLength > 0)
        self.maxLength = maxLength
        self.bufferingLength = bufferingLength
        status = .EMPTY
    }
    
    // This may result in hanging on waitForSpace condition.
    // Note that if multiple threads are waiting for free space, the order of waking them up is undefined.
    func pushBack(elem: T) {
        lock.lock()
        // Wait until there is space in the buffer.
        assert(!writerWaiting)
        writerWaiting = true
        while q.count >= maxLength {
            lock.unlock()
            waitForSpace.wait()
            lock.lock()
        }
        writerWaiting = false
        // Now there is an empty spot in the queue.
        
        // Place the element
        q.pushBack(elem)
        
        // Change the status of the buffer and notify if there are enough elements.
        if status == .EMPTY && q.count == bufferingLength {
            status = .NORMAL
            if readerWaiting {
                waitForData.signal()
            }
        }
        
        lock.unlock()
    }
    
    func popFront() -> T {
        lock.lock()
        // Wait until there is space in the buffer.
        assert(!readerWaiting)
        readerWaiting = true
        while status == .EMPTY || q.count < bufferingLength {
            lock.unlock()
            waitForData.wait()
            lock.lock()
        }
        readerWaiting = false
        // Now we can read from the queue.
        
        // Grab an element
        let elem = q.popFront()!
        
        // Mark as empty if there are no elements.
        if q.isEmpty() {
            status = .EMPTY
        }
        
        // Wake the writer if he might be waiting (note that we might trigger a couple of times for one writer the same writer if he doesn't wake up fast enough).
        if writerWaiting {
            waitForSpace.signal()
        }
        
        lock.unlock()
        return elem
    }
    
    var count: UInt32 {
        var cnt: UInt32 = 0
        lock.lock()
            cnt = q.count
        lock.unlock()
        return cnt
    }
    
    func isEmpty() -> Bool {
        var ret = false
        lock.lock()
            ret = q.isEmpty()
        lock.unlock()
        return ret
    }
}

enum QuickBufferStatus {
    case NORMAL
    case EMPTY
}