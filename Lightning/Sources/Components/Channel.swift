//
//  Channel.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

/// An event bus object which provides an API to broadcast messages to its subscribers.
public class Channel<Value> {
    
    internal class Subscription {
        
        weak var object: AnyObject?
        private let notifyBlock: (Value) -> Void
        private let queue: DispatchQueue
        
        var isValid: Bool {
            return object != nil
        }
        
        init(object: AnyObject?, queue: DispatchQueue, notifyBlock: @escaping (Value) -> Void) {
            self.object = object
            self.queue = queue
            self.notifyBlock = notifyBlock
        }
        
        func notify(_ value: Value, completion: (() -> Void)? = nil) {
            queue.async { [weak self] in
                guard let strongSelf = self else { return }
                
                if strongSelf.isValid {
                    strongSelf.notifyBlock(value)
                }
                
                completion?()
            }
        }
    }
    
    internal var subscriptions: Protected<[Subscription]> = Protected([])
    private let queue: DispatchQueue
    
    /// Creates a channel instance.
    ///
    /// - Parameter defaultBroadcastQueue: Default queue to use while notifying subscriptions.
    public init(defaultBroadcastQueue: DispatchQueue = .main) {
        self.queue = defaultBroadcastQueue
    }
    
    /// Subscribes given object to the channel. (Notifies on `defaultBroadcastQueue`.)
    ///
    /// - Parameters:
    ///   - object: Object to subscribe.
    ///   - notifyBlock: Block to call for notification.
    public func subscribe(_ object: AnyObject?, notifyBlock: @escaping (Value) -> Void) {
        self.subscribe(object, queue: self.queue, notifyBlock: notifyBlock)
    }
    
    /// Subscribes given object to channel.
    ///
    /// - Parameters:
    ///   - object: Object to subscribe.
    ///   - queue: Queue to notify on.
    ///   - notifyBlock: Block to call for notification.
    public func subscribe(_ object: AnyObject?, queue: DispatchQueue, notifyBlock: @escaping (Value) -> Void) {
        let subscription = Subscription(object: object, queue: queue, notifyBlock: notifyBlock)
        
        subscriptions.write { list in
            list.append(subscription)
        }
    }
    
    
    /// Unsubscribes given object from channel.
    ///
    /// - Parameter object: Object to remove.
    public func unsubscribe(_ object: AnyObject?) {
        subscriptions.write { list in
            if let foundIndex = list.index(where: { $0.object === object }) {
                list.remove(at: foundIndex)
            }
        }
    }
    
    /// Broadcasts given value to subscribers.
    ///
    /// - Parameters:
    ///   - value: Value to broadcast.
    ///   - completion: Completion handler called after notifing all subscribers.
    public func broadcast(_ value: Value, completion: (() -> Void)? = nil) {
        subscriptions.write { [weak self] list in
            guard let strongSelf = self else { return }
            
            list = list.filter({ $0.isValid })
            
            let group = DispatchGroup()
            
            for subscriber in list {
                group.enter()
                subscriber.notify(value) {
                    group.leave()
                }
            }
            
            group.wait()
            group.notify(queue: strongSelf.queue) {
                completion?()
            }
        }
    }
}
