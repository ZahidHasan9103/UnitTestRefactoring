//
//  MockPasswordChanger.swift
//  RefactoringTests
//
//  Created by ZEUS on 5/7/24.
//

import Foundation
import XCTest
@testable import Refactoring

final class MockPasswordChanger: PasswordChanging{
    
    private var changeCallCount = 0
    private var changeArgsSecurityToken: [String] = []
    private var changeArgsOldPassword: [String] = []
    private var changeArgsNewPassword: [String] = []
    private var changeArgsOnSuccess: [() -> Void] = []
    private var changeArgsOnFailure: [(String) -> Void] = []
    
    func change(securityToken: String, 
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void) {
        
        changeCallCount += 1
        changeArgsSecurityToken.append(securityToken)
        changeArgsOldPassword.append(oldPassword)
        changeArgsNewPassword.append(newPassword)
        changeArgsOnSuccess.append(onSuccess)
        changeArgsOnFailure.append(onFailure)
        
    }
    
    func verifyChange(securityToken: String,
                      oldPassword: String,
                      newPassword: String,
                      file: StaticString = #file,
                      line: UInt = #line){
        guard changeWasCalledOnce(file: file, line: line) else {return}
        XCTAssertEqual(changeArgsSecurityToken.last,
                       securityToken,
                       "securityToken",
                       file: file,
                       line: line)
        XCTAssertEqual(changeArgsOldPassword.last,
                       oldPassword,
                       "old password",
                       file: file,
                       line: line)
        XCTAssertEqual(changeArgsNewPassword.last,
                       newPassword,
                       "new password",
                       file: file,
                       line: line)
    }
    
    func verifyChangeNeverCalled(
        file: StaticString = #file,
        line: UInt = #line){
        changeWasNeverCalled(file: file, line: line)
    }
    
    private func changeWasCalledOnce(
        file: StaticString = #file,
        line: UInt = #line) -> Bool {
            verifyMethodCalledOnce(
                methodName: changeMethodName,
                callCount: changeCallCount, 
                describeArguments: changeMethodArguments,
                file: file,
                line: line)
        }
    
    private func changeWasNeverCalled(file: StaticString = #file, line: UInt = #line){
        verifyMethodNeverCalled(
            methodName: changeMethodName,
            callCount: changeCallCount,
            describeArguments: changeMethodArguments,
            file: file,
            line: line)
    }
    
    func changeCallSuccess(file: StaticString = #file, line: UInt = #line){
        guard changeWasCalledOnce() else {return}
        changeArgsOnSuccess.last!()
    }
    
    func changeCalledFailure(message: String, file: StaticString = #file, line: UInt = #line){
        guard changeWasCalledOnce() else {return}
        changeArgsOnFailure.last!(message)
    }
    
    private var changeMethodName: String{
        "change(securityToken:oldPassword:newPassword:onSuccess:onFailure:)"
    }
    
    private var changeMethodArguments: String{
        "oldPasswords: \(changeArgsOldPassword), " + "newPassword: \(changeArgsNewPassword)"
    }
    
}
