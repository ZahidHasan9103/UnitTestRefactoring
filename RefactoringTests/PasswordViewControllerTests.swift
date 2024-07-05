//
//  PasswordViewControllerTests.swift
//  RefactoringTests
//
//  Created by ZEUS on 5/7/24.
//

import XCTest
import ViewControllerPresentationSpy
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
        executeRunLoop()
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
    
    func test_cancelBarButton_shouldBeSystemItemCancel(){
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }
    
    func test_oldPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }
    
    func test_submitButton_shouldHaveTitle(){
        XCTAssertEqual(sut.submitButton.titleLabel?.text, "Submit")
    }
    
    func test_oldPasswordTextField_shouldHavePasswordAttributes(){
        let textField = sut.oldPasswordTextField!
        XCTAssertEqual(textField.textContentType, .password)
        XCTAssertTrue(textField.isSecureTextEntry)
        XCTAssertTrue(textField.enablesReturnKeyAutomatically)

    }
    
    func test_newPasswordTextField_shouldHavePasswordAttributes(){
        let textField = sut.newPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword)
        XCTAssertTrue(textField.isSecureTextEntry)
        XCTAssertTrue(textField.enablesReturnKeyAutomatically)

    }
    
    func test_confirmPasswordTextField_shouldHavePasswordAttributes(){
        let textField = sut.confirmPasswordTextField!
        
        XCTAssertEqual(textField.textContentType, .newPassword)
        XCTAssertTrue(textField.isSecureTextEntry)
        XCTAssertTrue(textField.enablesReturnKeyAutomatically)
    }
    
    func test_tappingCancel_withFocusOnPasswordTextField_shouldResignThatFocus(){
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnNewPasswordTextField_shouldResignThatFocus(){
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnConfirmPasswordTextField_shouldResignThatFocus(){
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    @MainActor func test_tappingCancel_shouldDismissModal(){
        let dismissalVerifier = DismissalVerifier()
        
        tap(sut.cancelBarButton)
        
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }
    
    //MARK - Helper Methods
    private func putFocusOn(textField: UITextField){
        putInViewHierarchy(sut)
        textField.becomeFirstResponder()
    }
}
