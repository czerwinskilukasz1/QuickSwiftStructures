//
//  DataBuffer.swift
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
    
    // Condition for the queue operations and for writer/reader waiting (we're rechecking the condition, so both could wait on the same variable)
    private let cond = NSCondition()
    
    let maxLength: UInt32
    let bufferingLength: UInt32
    private let q = QuickQueue<T>()
    private var status: QuickBufferStatus
    
    private var writerWaiting = false
    private var readerWaiting = false
    
    // @param maxLength - length of the buffer (needs to be greater than 0)
    // @param bufferingLength - if readers are waiting for a buffer to fill (they had emptied the buffer), there needs to be at least bufferingLength items there to wake them up
    init(maxLength: UInt32, bufferingLength: UInt32) {
        assert(maxLength > 0)
        assert(maxLength >= bufferingLength)
        self.maxLength = maxLength
        self.bufferingLength = bufferingLength
        status = .EMPTY
    }
    
    // If blocking is true, this call may result in hanging on cond condition if the queue is full.
    // If condDelayMs is specified, the condition will wait condDelayMs and then recheck. Returns false if queue is still full.
    // Note that if multiple threads are waiting for free space, the order of waking them up is undefined.
    func pushBack(elem: T, blocking: Bool = true, condDelayMs: Double? = nil) -> Bool {
        cond.lock()
        if blocking {
            // Wait until there is space in the buffer.
            assert(!writerWaiting)
            writerWaiting = true
            while q.count >= maxLength {
                if condDelayMs == nil {
                    cond.wait()
                } else {
                    let limitDate = NSDate().dateByAddingTimeInterval(condDelayMs!/1000)
                    cond.waitUntilDate(limitDate)
                    if q.count >= maxLength {
                        writerWaiting = false
                        cond.unlock()
                        return false
                    }
                }
            }
            writerWaiting = false
        } else {
            if q.count >= maxLength {
                return false
            }
        }
        // Now there is an empty spot in the queue.
        
        // Place the element
        q.pushBack(elem)
        
        // Change the status of the buffer and notify if there are enough elements.
        if status == .EMPTY && q.count >= bufferingLength {
            status = .NORMAL
            if readerWaiting {
                cond.broadcast()
            }
        }
        
        cond.unlock()
        return true
    }
    
    // Will block if buffer is empty (not full enough) if blocking is set to True (if false, it will return nil).
    func popFront(blocking: Bool = true) -> T? {
        cond.lock()
        // Wait until there is space in the buffer.
        if blocking {
            assert(!readerWaiting)
            readerWaiting = true
            while status == .EMPTY {
                cond.wait()
            }
            readerWaiting = false
        } else {
            if status == .EMPTY {
                cond.unlock()
                return nil
            }
        }
        // Now we can read from the queue.
        
        // Grab an element
        let elem = q.popFront()!
        
        // Mark as empty if there are no elements.
        if q.isEmpty() {
            status = .EMPTY
        }
        
        // Wake the writer if he might be waiting (note that we might trigger a couple of times for one writer the same writer if he doesn't wake up fast enough).
        if writerWaiting {
            cond.broadcast()
        }
        
        cond.unlock()
        return elem
    }
    
    var count: UInt32 {
        var cnt: UInt32 = 0
        cond.lock()
        cnt = q.count
        cond.unlock()
        return cnt
    }
    
    func isEmpty() -> Bool {
        var ret = false
        cond.lock()
        ret = q.isEmpty()
        cond.unlock()
        return ret
    }
    
    func removeAll() {
        cond.lock()
        q.removeAll()
        status = .EMPTY
        
        if writerWaiting {
            cond.broadcast()
        }
        cond.unlock()
    }
}

enum QuickBufferStatus {
    case NORMAL
    case EMPTY
}