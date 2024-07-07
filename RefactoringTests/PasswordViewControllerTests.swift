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
    var passwordChanger: MockPasswordChanger!
    var alertVerifier: AlertVerifier!
    
    @MainActor override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        passwordChanger = MockPasswordChanger()
        sut.passwordChanger = passwordChanger
        alertVerifier = AlertVerifier()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        passwordChanger = nil
        alertVerifier = nil
        super.tearDown()
    }
    
    //MARK: - Outlet connection not nil
    func test_outlets_shouldBeConnected(){
        XCTAssertNotNil(sut.cancelBarButton, "cancelBarButton")
        XCTAssertNotNil(sut.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton, "submitButton")
        XCTAssertNotNil(sut.navigationBar, "navigationBar")
    }
    
    //MARK: - NavigationBar configuration
    func test_navigationBar_shouldHaveTitle(){
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }
    
    func test_cancelBarButton_shouldBeSystemItemCancel(){
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }
    
    //MARK: - Textfield Placeholder
    func test_oldPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceholder(){
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }
    
    //MARK: - Button title
    func test_submitButton_shouldHaveTitle(){
        XCTAssertEqual(sut.submitButton.titleLabel?.text, "Submit")
    }
    
    //MARK: - Textfields attributes
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
    
    //MARK: -  CANCEL Button tap
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
    
    //MARK: - SUBMIT Button Tap
    
    //MARK: TextFields Validation Test
    func test_tappingSubmit_withOldPasswordEmpty_shouldNotChangePassword(){
        setupValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldPutFocusOnOldPassword(){
        setupValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        putInViewHierarchy(sut)
        
        tap(sut.submitButton)
        
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldNotChangePassword(){
        setupValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor func test_tappingSubmit_withNewPasswordEmpty_shouldShowPasswordBlankAlert(){
        setupValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        
        tap(sut.submitButton)
        
        verifyAlertPresented(message: "Please enter a new password.")
        
    }
    
    @MainActor func test_tappingOKPasswordBlankAlert_shouldFocusOnNewTextField() throws{
         setupValidPasswordEntries()
         sut.newPasswordTextField.text = ""
         tap(sut.submitButton)
         putInViewHierarchy(sut)
         
         try alertVerifier.executeAction(forButton: "OK")
         
         XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordTooShort_shouldNotChangePassword(){
        setupEntriesNewPasswordTooShort()
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor func test_tappingSubmit_withPasswordTooShort_shouldShowTooShortAlert(){
        setupEntriesNewPasswordTooShort()
        
        tap(sut.submitButton)
        
        verifyAlertPresented(message: "The new password should have at least 6 characters.")
    }
    
    @MainActor func test_tappingOKInTooShortAlert_shouldClearNewAndConfirmPassword() throws{
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirm")
    }
    
    @MainActor func test_tappingOKInTooShortAlert_shouldNotChangeOldPassword() throws{
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }
    
    @MainActor func test_tappingOKInTooShortAlert_shouldPutFocusOnNewPassword() throws{
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        putInViewHierarchy(sut)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldNotChangePassword(){
        setupMisMatchConfirmationEntry()
        
        tap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor func test_tappingSubmit_withConfirmationMisMatch_shouldShowPasswordMisMatchAlert(){
        setupMisMatchConfirmationEntry()
        
        tap(sut.submitButton)
        
        verifyAlertPresented(message: "The new password and the confirm password don\'t match. Please try again")
        
    }
    
    @MainActor func test_tappingOkInPasswordMismatchAlert_shouldClearNewAndConfirmPassword() throws {
        setupMisMatchConfirmationEntry()
        tap(sut.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirm")
        
    }
    
    @MainActor func test_tappingOkInPasswordMismatchAlert_shouldPutFocusOnNewPassword() throws{
        setupMisMatchConfirmationEntry()
        tap(sut.submitButton)
        putInViewHierarchy(sut)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    //MARK - Helper Methods
    private func putFocusOn(textField: UITextField){
        putInViewHierarchy(sut)
        textField.becomeFirstResponder()
    }
    
    private func setupValidPasswordEntries(){
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func setupEntriesNewPasswordTooShort(){
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "12345"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func setupMisMatchConfirmationEntry(){
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = "234567"
    }
    
    @MainActor private func verifyAlertPresented(
        message: String,
        file: StaticString = #file,
        line: UInt = #line){
        
            alertVerifier.verify(title: "",
                                 message: message,
                                 animated: true,
                                 actions: [
                                    .default("OK")
                                 ],
                                 presentingViewController: sut,
                                 file: file,
                                 line: line
            )
            XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action", file: file, line: line)
    }
}
