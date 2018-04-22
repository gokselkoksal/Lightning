//
//  ChannelTests.swift
//  Lightning iOS Tests
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ChannelTests: XCTestCase {
    
    enum Message {
        case m1
        case m2
        case m3
        case m4
    }
    
    func testUserInterfaceMode() throws {
        try executeTestCase(queue: DispatchQueue.main)
    }
    
    func testTaskMode() throws {
        try executeTestCase(queue: DispatchQueue.global(qos: .background))
        try executeTestCase(queue: DispatchQueue.global(qos: .default))
        try executeTestCase(queue: DispatchQueue.global(qos: .unspecified))
        try executeTestCase(queue: DispatchQueue.global(qos: .userInitiated))
        try executeTestCase(queue: DispatchQueue.global(qos: .userInteractive))
        try executeTestCase(queue: DispatchQueue.global(qos: .utility))
    }
    
    func testCustomMode() throws {
        let queue = DispatchQueue(label: "test.channel", attributes: .concurrent)
        try executeTestCase(queue: queue)
    }
    
    private func executeTestCase(queue: DispatchQueue, file: StaticString = #file, line: UInt = #line) throws {
        let listener1: ChannelListener<Message>? = ChannelListener()
        var listener2: ChannelListener<Message>? = ChannelListener()
        var listener3: ChannelListener<Message>? = ChannelListener()
        let listener4: ChannelListener<Message>? = ChannelListener()
        
        let channel = Channel<Message>(defaultBroadcastQueue: queue)
        
        XCTAssertEqual(channel.subscriptions.value.count, 0, file: file, line: line)
        
        listener1?.subscribe(to: channel)
        listener2?.subscribe(to: channel)
        listener3?.subscribe(to: channel)
        listener4?.subscribe(to: channel)
        
        XCTAssertEqual(channel.subscriptions.value.count, 4, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object === listener2, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 2).object === listener3, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 3).object === listener4, file: file, line: line)
        
        waitExecution(for: "broadcasting m1") { (finish) in
            channel.broadcast(.m1, completion: finish)
        }
        
        waitExecution(for: "broadcasting m2") { (finish) in
            channel.broadcast(.m2, completion: finish)
        }
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2], file: file, line: line)
        XCTAssertEqual(try listener2.unwrap().messages, [.m1, .m2], file: file, line: line)
        XCTAssertEqual(try listener3.unwrap().messages, [.m1, .m2], file: file, line: line)
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2], file: file, line: line)
        
        listener2 = nil
        listener3 = nil
        
        XCTAssertEqual(channel.subscriptions.value.count, 4, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object == nil, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 2).object == nil, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 3).object === listener4, file: file, line: line)
        
        waitExecution(for: "broadcasting m3") { (finish) in
            channel.broadcast(.m3, completion: finish)
        }
        
        // Expecting removal of nil references in subscription list upon broadcast:
        XCTAssertEqual(channel.subscriptions.value.count, 2, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object === listener4, file: file, line: line)
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2, .m3], file: file, line: line)
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2, .m3], file: file, line: line)
        
        channel.unsubscribe(listener1)
        
        XCTAssertEqual(channel.subscriptions.value.count, 1, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener4, file: file, line: line)
        
        waitExecution(for: "broadcasting m4") { (finish) in
            channel.broadcast(.m4, completion: finish)
        }
        
        XCTAssertEqual(channel.subscriptions.value.count, 1, file: file, line: line)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener4, file: file, line: line)
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2, .m3], file: file, line: line)
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2, .m3, .m4], file: file, line: line)

    }
}

private class ChannelListener<Message> {
    
    private(set) var messages: [Message] = []
    
    func subscribe(to channel: Channel<Message>) {
        channel.subscribe(self) { [weak self] (message) in
            self?.messages.append(message)
        }
    }
}
