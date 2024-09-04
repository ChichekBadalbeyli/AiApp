//
//  ProfileController.swift
//  AI
//
//  Created by Chichek on 01.09.24.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var currentPasswordLabel: UILabel!
    
    @IBOutlet weak var newPasswordLabel: UILabel!
    
    @IBOutlet weak var updateInfoButton: UIButton!
    
    @IBOutlet weak var myView: UIView!
    
    private var isGoogleUser: Bool = false
    
    override func viewDidLoad() {
        loadProfileInformation()
        super.viewDidLoad()
        emailTextField.isUserInteractionEnabled = false
        newPasswordTextField.isUserInteractionEnabled = false
        newPasswordTextField.isHidden = true
        updateInfoButton.isHidden = true
        currentPasswordTextField.isHidden = true
        currentPasswordLabel.isHidden = true
        newPasswordLabel.isHidden = true
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myView.layer.shadowRadius = 4
    }
    
    func loadProfileInformation() {
        if let user = Auth.auth().currentUser {
            emailTextField.text = user.email
            fullnameTextField.text = user.displayName ?? "No Name"
            
            // Check if the user is signed in with Google
            for userInfo in user.providerData {
                if userInfo.providerID == "google.com" {
                    isGoogleUser = true
                    break
                }
            }
        }
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        if isGoogleUser {
            // Enable editing directly for Google users
            enableEditing()
        } else {
            // Prompt for password for email/password authenticated users
            promptForPassword()
        }
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        guard let newEmail = emailTextField.text, !newEmail.isEmpty else {
              showAlert(message: "Please enter a valid email address.")
              return
          }
          
          if let newName = fullnameTextField.text, !newName.isEmpty {
              let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
              changeRequest?.displayName = newName
              changeRequest?.commitChanges { error in
                  if let error = error {
                      self.showAlert(message: "Failed to update name: \(error.localizedDescription)")
                  } else {
                      self.showAlert(message: "Name updated successfully.")
                  }
              }
          }
          
          Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
              if let error = error {
                  self.showAlert(message: "Failed to update email: \(error.localizedDescription)")
              } else {
                  self.showAlert(message: "Email updated successfully.")
                  self.emailTextField.isUserInteractionEnabled = false
                  self.newPasswordTextField.isUserInteractionEnabled = false
                  self.updateInfoButton.isHidden = true
              }
          }
          
          // Only update password for non-Google users
          if !isGoogleUser, let newPassword = newPasswordTextField.text, !newPassword.isEmpty {
              Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                  if let error = error {
                      self.showAlert(message: "Failed to update password: \(error.localizedDescription)")
                  } else {
                      self.showAlert(message: "Password updated successfully.")
                  }
              }
          }
    }
    
    private func promptForPassword() {
        let alert = UIAlertController(title: "Enter Current Password", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            if let currentPassword = alert.textFields?.first?.text, !currentPassword.isEmpty {
                self.reauthenticateUser(currentPassword: currentPassword)
            } else {
                self.showAlert(message: "Please enter your current password.")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func reauthenticateUser(currentPassword: String) {
        guard let email = Auth.auth().currentUser?.email else {
            showAlert(message: "User email not found.")
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential) { result, error in
            if let error = error {
                self.showAlert(message: "Password is incorrect. Please try again.")
                print("Re-authentication failed: \(error.localizedDescription)")
            } else {
                self.enableEditing()
            }
        }
    }
    
    private func enableEditing() {
        emailTextField.isUserInteractionEnabled = true
        fullnameTextField.isUserInteractionEnabled = true
        newPasswordTextField.isUserInteractionEnabled = true
        updateInfoButton.isHidden = false
        currentPasswordTextField.isHidden = false
        currentPasswordLabel.isHidden = false
        newPasswordTextField.isHidden = false
        newPasswordLabel.isHidden = false
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}


