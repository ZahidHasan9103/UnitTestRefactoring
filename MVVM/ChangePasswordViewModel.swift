//
//  ChangePasswordViewModel.swift
//  Refactoring
//
//  Created by ZEUS on 8/7/24.
//

import Foundation

struct ChangePasswordViewModel{
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
}
