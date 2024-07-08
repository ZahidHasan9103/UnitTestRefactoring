//
//  ViewController.swift
//  Refactoring
//
//  Created by ZEUS on 4/7/24.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "changePassword"{
            let changePasswordVC = segue.destination as? ChangePasswordViewController
            changePasswordVC?.securityToken = "TOKEN"
            changePasswordVC?.viewModel = ChangePasswordViewModel(okButtonLabel: "OK")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

