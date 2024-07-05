//
//  PasswordViewControllerTests.swift
//  RefactoringTests
//
//  Created by ZEUS on 5/7/24.
//

import XCTest
@testable import Refactoring
final class PasswordViewControllerTests: XCTestCase {

    var sut: ChangePasswordViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_outlets_shouldBeConnected(){
        XCTAssertNotNil(sut.cancelBarButton, "cancelBarButton")
        XCTAssertNotNil(sut.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton, "submitButton")
        XCTAssertNotNil(sut.navigationBar, "navigationBar")
    }
    
    func test_navigationBar_shouldHaveTitle(){
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }
    
}
