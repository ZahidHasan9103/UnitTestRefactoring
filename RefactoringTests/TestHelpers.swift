//
//  TestHelpers.swift
//  RefactoringTests
//
//  Created by ZEUS on 5/7/24.
//

import Foundation
import XCTest

func verifyMethodCalledOnce(
    methodName: String,
    callCount: Int,
    describeArguments: @autoclosure () -> String,
    file: StaticString = #file,
    line: UInt = #line) -> Bool{
        if callCount == 0 {
            XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        }
        
        if callCount > 1{
            XCTFail("Wanted 1 time but was called: \(callCount) " + "\(methodName) with \(describeArguments())", file: file, line: line)
        }
        return true
    }

func verifyMethodNeverCalled(
    methodName: String,
    callCount: Int,
    describeArguments: @autoclosure () -> String,
    file: StaticString = #file,
    line: UInt = #line){
        let time = callCount == 1 ? "time" : "times"
        
        if callCount > 0{
            XCTFail("Never wanted but was called \(callCount) \(time) " + "\(methodName) with \(describeArguments())", file: file, line: line)
        }
    }
