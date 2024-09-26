////
////  LoginViewController.swift
////  AI
////
////  Created by Chichek on 23.08.24.
////
import UIKit
import FirebaseAuth
import Lottie

import UIKit
class LoginViewController: UIViewController {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    @IBAction func login(_ sender: Any) {
        if let email = email.text, !email.isEmpty,
           let password = password.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.showAlert(message: "Please enter valid e-mail adress and password.")
                    return
                }
                if let scene = UIApplication.shared.connectedScenes.first,
                   let sceneDelegate = scene.delegate as? SceneDelegate {
                    sceneDelegate.setHomeAsRoot()
                }
            }
        } else {
            showAlert(message: "Please enter both email and password.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkCurrentUser() {
        if let user = Auth.auth().currentUser {
            print("User is signed in with UID: \(user.uid)")
        } else {
            print("No user is signed in.")
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if let coordinator = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            present(coordinator, animated: true, completion: nil)}
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let coordinator = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            present(coordinator, animated: true, completion: nil)}
    }
    
    @IBAction func passwordEditing(_ sender: Any) {
        password.isSecureTextEntry = true
    }
}
