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
    
    func testBroadcasting() throws {
        let listener1: ChannelListener<Message>? = ChannelListener()
        var listener2: ChannelListener<Message>? = ChannelListener()
        var listener3: ChannelListener<Message>? = ChannelListener()
        let listener4: ChannelListener<Message>? = ChannelListener()
        
        let channel = Channel<Message>()
        
        XCTAssertEqual(channel.subscriptions.value.count, 0)
        
        listener1?.subscribe(to: channel)
        listener2?.subscribe(to: channel)
        listener3?.subscribe(to: channel)
        listener4?.subscribe(to: channel)
        
        XCTAssertEqual(channel.subscriptions.value.count, 4)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object === listener2)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 2).object === listener3)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 3).object === listener4)
        
        channel.broadcast(.m1)
        channel.broadcast(.m2)
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2])
        XCTAssertEqual(try listener2.unwrap().messages, [.m1, .m2])
        XCTAssertEqual(try listener3.unwrap().messages, [.m1, .m2])
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2])
        
        listener2 = nil
        listener3 = nil
        
        XCTAssertEqual(channel.subscriptions.value.count, 4)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object == nil)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 2).object == nil)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 3).object === listener4)
        
        channel.broadcast(.m3)
        
        // Expecting removal of nil references in subscription list upon broadcast:
        XCTAssertEqual(channel.subscriptions.value.count, 2)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener1)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 1).object === listener4)
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2, .m3])
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2, .m3])
        
        channel.unsubscribe(listener1)
        
        XCTAssertEqual(channel.subscriptions.value.count, 1)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener4)
        
        channel.broadcast(.m4)
        
        XCTAssertEqual(channel.subscriptions.value.count, 1)
        XCTAssertTrue(try channel.subscriptions.value.element(at: 0).object === listener4)
        
        XCTAssertEqual(try listener1.unwrap().messages, [.m1, .m2, .m3])
        XCTAssertEqual(try listener4.unwrap().messages, [.m1, .m2, .m3, .m4])
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
