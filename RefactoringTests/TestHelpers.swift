//
//  TestHelpers.swift
//  RefactoringTests
//
//  Created by ZEUS on 5/7/24.
//

import UIKit
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

func systemItem(for barButtonItem: UIBarButtonItem) -> UIBarButtonItem.SystemItem{
    let systemItemNumber = barButtonItem.value(forKey: "systemItem") as! Int
    return UIBarButtonItem.SystemItem(rawValue: systemItemNumber)!
}


extension UIBarButtonItem.SystemItem: CustomStringConvertible{
    public var description: String {
        switch self {
        case .done:
            "done"
        case .cancel:
            "cancel"
        case .edit:
            "edit"
        case .save:
            "save"
        case .add:
            "add"
        case .flexibleSpace:
            "flexibleSpace"
        case .fixedSpace:
            "fixedSpace"
        case .compose:
            "compose"
        case .reply:
            "replu"
        case .action:
            "action"
        case .organize:
            "organize"
        case .bookmarks:
            "bookmarks"
        case .search:
            "search"
        case .refresh:
            "refresh"
        case .stop:
            "stop"
        case .camera:
            "camera"
        case .trash:
            "trash"
        case .play:
            "play"
        case .pause:
            "pause"
        case .rewind:
            "rewind"
        case .fastForward:
            "fastforward"
        case .undo:
            "undo"
        case .redo:
            "redo"
        case .pageCurl:
            "pageCurl"
        case .close:
            "close"
        @unknown default:
            fatalError("Unknown UIBarButton.SystemItem")
        }
    }
}
