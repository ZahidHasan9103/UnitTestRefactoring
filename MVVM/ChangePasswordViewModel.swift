//
//  ChangePasswordViewModel.swift
//  Refactoring
//
//  Created by ZEUS on 8/7/24.
//

import Foundation

struct ChangePasswordViewModel{
    
    enum InputFocus{
        case noKeyboard
        case oldPassword
        case newPassword
        case confirmPassword
    }
    
    let okButtonLabel: String
    let enterNewPasswordMessage: String
    let newPasswordTooShortMessage: String
    let confirmationPasswordDoesNotMatchMessage: String
    let successMessage: String
    let title = "Change Password"
    let oldPasswordPlaceHolder = "Current Password"
    let newPasswordPlaceHolder = "New Password"
    let confirmPasswordPlaceholder = "Confirm New Password"
    let submitButtonTitle = "Submiit"
    
    var isCancelButtonEnabled: Bool = true
    var inputFocus: InputFocus = .noKeyboard
    var isBlurViewShowing = false
    var isActivityIndicatorShowing = false
    
    var oldPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    
    var isOldPasswordEmpty: Bool{oldPassword.isEmpty}
    var isNewPasswordEmpty: Bool{newPassword.isEmpty}
    var isNewPasswordTooShort: Bool{ newPassword.count
     < 6 }
    var isConfirmPasswordMisMatch: Bool{newPassword != confirmPassword}
}

