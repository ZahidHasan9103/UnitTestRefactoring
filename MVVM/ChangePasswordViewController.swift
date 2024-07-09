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
    
    var viewModel: ChangePasswordViewModel! {
        didSet{
            guard isViewLoaded else {return}
            if oldValue.isCancelButtonEnabled != viewModel.isCancelButtonEnabled{
                cancelBarButton.isEnabled = viewModel.isCancelButtonEnabled
            }
            
            if oldValue.inputFocus != viewModel.inputFocus{
                updateInputFocus()
            }
            
            if oldValue.isBlurViewShowing != viewModel.isBlurViewShowing{
                updateBlurView()
            }
            
            if oldValue.isActivityIndicatorShowing != viewModel.isActivityIndicatorShowing{
                updateActivityIndicator()
            }
        }
    }
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
        setLabels()
    }
    
    private func setLabels() {
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceHolder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceHolder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }
    
    @IBAction func cancel(_ sender: Any) {
        viewModel.inputFocus = .noKeyboard
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
            viewModel.inputFocus = .oldPassword
            return false
        }
        
        if newPasswordTextField.text?.isEmpty ?? true{
            showAlert(viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.viewModel.inputFocus = .newPassword
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
        viewModel.inputFocus = .noKeyboard
        viewModel.isCancelButtonEnabled = false
        viewModel.isBlurViewShowing = true
        viewModel.isActivityIndicatorShowing = true
        
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
    
    private func resetNewPassword() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        viewModel.inputFocus = .newPassword
    }
    
    private func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        viewModel.inputFocus = .oldPassword
        viewModel.isBlurViewShowing = false
        viewModel.isCancelButtonEnabled = true
    }
    
    private func handleSuccess(){
        viewModel.isActivityIndicatorShowing = false
        showAlert(viewModel.successMessage, okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    private func handleFailure(message: String){
        viewModel.isActivityIndicatorShowing = false
        showAlert(message, okAction: { [weak self] _ in
            self?.startOver()
        })
    }
    
    private func updateInputFocus() {
        switch viewModel.inputFocus {
        case .noKeyboard:
            view.endEditing(true)
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
    
    private func updateBlurView(){
        if viewModel.isBlurViewShowing{
            view.backgroundColor = .clear
            view.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
        }else{
            blurView.removeFromSuperview()
            view.backgroundColor = .white
        }
    }
    
    private func updateActivityIndicator(){
        if viewModel.isActivityIndicatorShowing{
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            activityIndicator.startAnimating()
        }else{
            hideSpinner()
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField{
            viewModel.inputFocus = .newPassword
        }else if textField === newPasswordTextField{
            viewModel.inputFocus = .confirmPassword
        }else if textField === confirmPasswordTextField{
            changePassword()
        }
        return true
    }
}
