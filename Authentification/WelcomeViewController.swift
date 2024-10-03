//
//  WelcomeViewController.swift
//  AI
//
//  Created by Chichek on 29.08.24.
//

import UIKit
import Lottie
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        if let coordinator = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            present(coordinator, animated: true, completion: nil)}
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        if let coordinator = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            present(coordinator, animated: true, completion: nil)}
        
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error = error {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    return
                }
                self?.navigateToHomeScreen()
            }
        }
    }
    
    func navigateToHomeScreen() {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = scene?.delegate as? SceneDelegate {
            sceneDelegate.setHomeAsRoot()
        } else {
            print("Failed to retrieve SceneDelegate")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

