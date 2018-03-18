//
//  Channel.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public class Channel<Value> {
    
    public enum Mode {
        
        /// Mode to deliver UI updates.
        case userInterface
        
        /// Mode to deliver updates on any task with given quality of service.
        case task(DispatchQoS.QoSClass)
        
        /// Mode to deliver updates on a custom queue.
        case custom(DispatchQueue)
        
        fileprivate func makeQueue() -> DispatchQueue {
            switch self {
            case .userInterface:
                return DispatchQueue.main
            case .task(let qos):
                return DispatchQueue.global(qos: qos)
            case .custom(let queue):
                return queue
            }
        }
    }
    
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
    
    public init(mode: Mode) {
        self.queue = mode.makeQueue()
    }
    
    public func subscribe(_ object: AnyObject?, notifyBlock: @escaping (Value) -> Void) {
        self.subscribe(object, queue: self.queue, notifyBlock: notifyBlock)
    }
    
    public func subscribe(_ object: AnyObject?, queue: DispatchQueue, notifyBlock: @escaping (Value) -> Void) {
        let subscription = Subscription(object: object, queue: queue, notifyBlock: notifyBlock)
        
        subscriptions.write { list in
            list.append(subscription)
        }
    }
    
    public func unsubscribe(_ object: AnyObject?) {
        subscriptions.write { list in
            if let foundIndex = list.index(where: { $0.object === object }) {
                list.remove(at: foundIndex)
            }
        }
    }
    
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
