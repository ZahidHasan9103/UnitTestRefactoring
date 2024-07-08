//
//  ChangePasswordViewController.swift
//  Refactoring
//
//  Created by ZEUS on 4/7/24.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet private(set) weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) weak var oldPasswordTextField: UITextField!
    
    @IBOutlet private(set) weak var newPasswordTextField: UITextField!
    @IBOutlet private(set) weak var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) weak var submitButton: UIButton!
    
    @IBOutlet private(set) weak var navigationBar: UINavigationBar!
    
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    var securityToken = ""
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(red: 55/255.0, green: 147/255.0, blue: 251/255.0, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 8
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .blue
    }
    
    @IBAction func cancel(_ sender: Any) {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        dismiss(animated: true)
    }
    
    @IBAction func changePassword() {

        guard validateInputs() else {return}
        setupWaitingAppearance()
        attemptToChangePassword()
    }
    
    private func validateInputs() -> Bool{
        
        //1. Validate inputs
        if oldPasswordTextField.text?.isEmpty ?? true{
            oldPasswordTextField.becomeFirstResponder()
            return false
        }
        
        if newPasswordTextField.text?.isEmpty ?? true{
            showAlert("Please enter a new password.") { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if newPasswordTextField.text?.count ?? 0 < 6{
            showAlert("The new password should have at least 6 characters.") { [weak self] _ in
                self?.newPasswordTextField.text = ""
                self?.confirmPasswordTextField.text = ""
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if newPasswordTextField.text != confirmPasswordTextField.text{
            showAlert("The new password and the confirm password " + "don't match. Please try again") { [weak self] _ in
                self?.newPasswordTextField.text = ""
                self?.confirmPasswordTextField.text = ""
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    
    private func setupWaitingAppearance() {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        cancelBarButton.isEnabled = false
        view.backgroundColor = .clear
        view.addSubview(blurView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()

    }
    
    private func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: oldPasswordTextField.text ?? "",
            newPassword: newPasswordTextField.text ?? "",
            onSuccess: {[weak self] in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                let alertController = UIAlertController(
                    title: nil,
                    message: "Your password has been changed successfully",
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style:
                        .default) { [weak self] _ in
                            self?.dismiss(animated: true)
                        }
                
                alertController.addAction(okAction)
                alertController.preferredAction = okAction
                self?.present(alertController, animated: true)
            }, onFailure: {[weak self] message in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style:
                        .default) { [weak self] _ in
                            self?.oldPasswordTextField.text = ""
                            self?.newPasswordTextField.text = ""
                            self?.confirmPasswordTextField.text = ""
                            self?.oldPasswordTextField.becomeFirstResponder()
                            self?.view.backgroundColor = .white
                            self?.blurView.removeFromSuperview()
                            self?.cancelBarButton.isEnabled = true
                        }
                alertController.addAction(okAction)
                alertController.preferredAction = okAction
                self?.present(alertController, animated: true)
            })
    }
    
    private func showAlert(_ message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        self.present(alertController, animated: true)
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField{
            newPasswordTextField.becomeFirstResponder()
        }else if textField === newPasswordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }else if textField === confirmPasswordTextField{
            changePassword()
        }
        return true
    }

}
