//
//  XCTestCase+CustomAssertions.swift
//  TweenKit
//
//  Created by Steven Barnegren on 24/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

extension XCTestCase {
    
    enum Filter {
        case none
        case onlyMatchingExpectedEventsTypes
        
        func apply(recordedEvents: [EventType],
                   expectedEvents: [EventType]) -> [EventType] {
            
            let expectedEventsAsStrings = expectedEvents.map{ $0.asString() }
            
            switch self {
            case .none:
                return recordedEvents
            case .onlyMatchingExpectedEventsTypes:
                return recordedEvents.filter{ recorded in expectedEventsAsStrings.contains(recorded.asString()) }
            }
        }
    }
    
    func AssertLifeCycleEventsAreAsExpected(recordedEvents: [EventType],
                                            expectedEvents: [EventType],
                                            filter: Filter,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        
        func stringFromEvents(_ events: [EventType]) -> String {
            
            var string = ""
            string += "["
            for event in events {
                string += "\n"
                string += event.asString()
            }
            
            if string != "[" {
                string += "\n"
            }
            
            string += "]"
            return string
        }
        
        // Filter events
        var recordedEvents = recordedEvents
        recordedEvents = filter.apply(recordedEvents: recordedEvents,
                                      expectedEvents: expectedEvents)
        
        // Generate strings for error messages
        let eventsAsString = stringFromEvents(recordedEvents)
        let otherEventsAsString = stringFromEvents(expectedEvents)
        
        // Assert
        XCTAssertEqual(eventsAsString,
                       otherEventsAsString,
                       "\n\nRECORDED EVENTS:\n\n\(eventsAsString)\n\nARE NOT EQUAL TO EXPECTED EVENTS:\n\n\(otherEventsAsString)\n\n",
            file: file,
            line: line)
    }
}

