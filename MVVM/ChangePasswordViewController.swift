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
    
    var viewModel: ChangePasswordViewModel!
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
        view.endEditing(true)
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
            showAlert(viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if newPasswordTextField.text?.count ?? 0 < 6{
            showAlert(viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        
        if newPasswordTextField.text != confirmPasswordTextField.text{
            showAlert(viewModel.confirmationPasswordDoesNotMatchMessage) { [weak self] _ in
                self?.resetNewPassword()
            }
            return false
        }
        return true
    }
    
    private func setupWaitingAppearance() {
        view.endEditing(true)
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
                self?.handleSuccess()
            }, 
            onFailure: {[weak self] message in
                self?.handleFailure(message: message)
            })
    }
    
    private func showAlert(_ message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: viewModel
            .okButtonLabel, style: .default, handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        self.present(alertController, animated: true)
    }
    
    private func resetNewPassword(){
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        newPasswordTextField.becomeFirstResponder()
    }
    
    private func hideSpinner(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func startOver(){
      oldPasswordTextField.text = ""
      newPasswordTextField.text = ""
      confirmPasswordTextField.text = ""
      oldPasswordTextField.becomeFirstResponder()
      view.backgroundColor = .white
      blurView.removeFromSuperview()
      cancelBarButton.isEnabled = true
    }
    
    private func handleSuccess(){
        hideSpinner()
        showAlert(viewModel.successMessage, okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    private func handleFailure(message: String){
        hideSpinner()
        showAlert(message, okAction: { [weak self] _ in
            self?.startOver()
        })
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
