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
        
        func apply(recordedEvents: [FiniteTimeActionTester.EventType],
                   expectedEvents: [FiniteTimeActionTester.EventType]) -> [FiniteTimeActionTester.EventType] {
            
            switch self {
            case .none:
                return recordedEvents
            case .onlyMatchingExpectedEventsTypes:
                return recordedEvents.filter{
                    return expectedEvents.contains($0)
                }
            }
        }
    }
    
    func AssertLifeCycleEventsAreAsExpected(recordedEvents: [FiniteTimeActionTester.EventType],
                                            expectedEvents: [FiniteTimeActionTester.EventType],
                                            filter: Filter,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        
        func stringFromEvents(_ events: [FiniteTimeActionTester.EventType]) -> String {
            
            var string = ""
            string += "["
            for event in events {
                
                let eventString: String
                switch event {
                case .willBecomeActive:
                    eventString = "Will Become Active"
                case .willBegin:
                    eventString = "Will Begin"
                case .didFinish:
                    eventString = "Did Finish"
                case .didBecomeInactive:
                    eventString = "Did Become Inactive"
                case .setReversed(let reversed):
                    eventString = "Set Reverse (\(reversed))"
                }
                string += "\n"
                string += eventString
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
        XCTAssertEqual(recordedEvents,
                       expectedEvents,
                       "\n\nRECORDED EVENTS:\n\n\(eventsAsString)\n\nARE NOT EQUAL TO EXPECTED EVENTS:\n\n\(otherEventsAsString)\n\n",
            file: file,
            line: line)
    }
}

