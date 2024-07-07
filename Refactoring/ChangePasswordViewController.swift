//
//  ChangePasswordViewController.swift
//  Refactoring
//
//  Created by ZEUS on 4/7/24.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private(set) weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) weak var oldPasswordTextField: UITextField!

    @IBOutlet private(set) weak var newPasswordTextField: UITextField!
    @IBOutlet private(set) weak var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) weak var submitButton: UIButton!
    
    @IBOutlet private(set) weak var navigationBar: UINavigationBar!
    
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    var securityToken = ""
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    
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
        //1. Validate inputs
        if oldPasswordTextField.text?.isEmpty ?? true{
            oldPasswordTextField.becomeFirstResponder()
            return
        }
        
        if newPasswordTextField.text?.isEmpty ?? true{
            let alertController = UIAlertController(title: nil, message: "Please enter a new password.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default){[weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            alertController.addAction(okButton)
            alertController.preferredAction = okButton
            self.present(alertController, animated: true)
            return
        }
        
        if newPasswordTextField.text?.count ?? 0 < 6{
            let alertController = UIAlertController(title: nil, message: "The new password should have at least 6 characters.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.newPasswordTextField.text = ""
                self?.confirmPasswordTextField.text = ""
                self?.newPasswordTextField.becomeFirstResponder()
            }
            
            alertController.addAction(okAction)
            alertController.preferredAction = okAction
            
            self.present(alertController, animated: true)
            return
        }
        
        if newPasswordTextField.text != confirmPasswordTextField.text{
            let alertController = UIAlertController(title: nil, message: "The new password and the confirm password " + "don't match. Please try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
                self?.newPasswordTextField.text = ""
                self?.confirmPasswordTextField.text = ""
                self?.newPasswordTextField.becomeFirstResponder()
            }
            alertController.addAction(okAction)
            alertController.preferredAction = okAction
            self.present(alertController, animated: true)
            return
        }
        
        //2. Set up waiting
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
        
        //3.Attempt to change Password
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
                alertController.addAction(
                    UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: { [weak self] _ in
                                      self?.dismiss(animated: true)
                }))
                self?.present(alertController, animated: true)
            }, onFailure: {[weak self] message in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                let alertController = UIAlertController(
                    title: nil,
                    message: message,
                    preferredStyle: .alert)
                alertController.addAction(
                    UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: { [weak self] _ in
                                      self?.oldPasswordTextField.text = ""
                                      self?.newPasswordTextField.text = ""
                                      self?.confirmPasswordTextField.text = ""
                                      self?.oldPasswordTextField.becomeFirstResponder()
                                      self?.view.backgroundColor = .white
                                      self?.blurView.removeFromSuperview()
                                      self?.cancelBarButton.isEnabled = true
                }))
                self?.present(alertController, animated: true)
                
                
            })
    }
    
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
