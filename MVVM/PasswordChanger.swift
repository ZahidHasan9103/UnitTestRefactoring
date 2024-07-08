//
//  PasswordChanger.swift
//  Refactoring
//
//  Created by ZEUS on 4/7/24.
//

import Foundation

final class PasswordChanger: PasswordChanging{
    private static var pretendToSuccess = false
    private var successOrFailureTimer: SuccessOrFailureTimer?
    
    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void){
        
        print("Initiate Password Change")
        print("SecurityToken: \(securityToken)")
        print("Old Password: \(oldPassword)")
        print("New Password: \(newPassword)")
        
        successOrFailureTimer = SuccessOrFailureTimer(onSuccess: onSuccess, onFailure: onFailure, timer: Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.callSuccessOrFailure()
        }))
        
    }
    
    private func callSuccessOrFailure(){
        if PasswordChanger.pretendToSuccess{
            successOrFailureTimer?.onSuccess()
        }else{
            successOrFailureTimer?.onFailure("Sorry, something went wrong")
        }
        PasswordChanger.pretendToSuccess.toggle()
        successOrFailureTimer?.timer.invalidate()
        successOrFailureTimer = nil
    }
}


private struct SuccessOrFailureTimer{
    let onSuccess: () -> Void
    let onFailure: (String) -> Void
    let timer: Timer
}

protocol PasswordChanging{
    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void)
}
