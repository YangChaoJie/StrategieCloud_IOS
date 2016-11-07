//
//  GCDTimer.swift
//  StockRemind
//
//  Created by dylan.zhang on 15/8/29.
//  Copyright (c) 2015年 dylan.zhang. All rights reserved.
//

import Foundation

public class GCDTimer {

    // Serial dispatch queue, 先进先出
    private static let gcdTimerQueue = dispatch_queue_create("com.ringear.StockRemind.gcdTimerQueue", DISPATCH_QUEUE_SERIAL)
    
    // Timer Source
    private let timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, GCDTimer.gcdTimerQueue)
    
    // Default internal: 1 second
    private var interval: Double = 1
    
    // Event that is executed repeatedly
    private var event: (() -> Void)!
    
    public var isRunning = false
    
    public var Event: (() -> Void) {
        get {
            return event
        }
        set {
            event = newValue
            
            dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, UInt64(interval * Double(NSEC_PER_SEC)), 0)
            dispatch_source_set_event_handler(timerSource, { () -> Void in
                self.event()
            })
        }
    }
    
    public init(intervalInsecs: Double) {
        self.interval = intervalInsecs
    }
    
    // Start the timer.
    public func start() {
        isRunning = true
        dispatch_resume(timerSource)
    }
    
    // Pause the timer.
    public func pause() {
        isRunning = false
        dispatch_suspend(timerSource)
    }
    
    /**
    Executes a block after a delay on the main thread.
    */
    public class func delay(afterSecs: Double, block: dispatch_block_t) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterSecs * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), block)
    }
    
    /**
    Executes a block after a delay on a specified queue.
    */
    public class func delay(afterSecs: Double, queue: dispatch_queue_t, block: dispatch_block_t) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterSecs * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, block)
    }
}