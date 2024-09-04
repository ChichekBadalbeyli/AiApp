//
//  ForgotPasswordController.swift
//  AI
//
//  Created by Chichek on 25.08.24.
//
import UIKit
import FirebaseAuth
import Lottie

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    @IBOutlet weak var emailTextField: UITextField!
    
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .invalidEmail:
                    self?.showAlert(message: "Please enter a valid email address.")
                default:
                    self?.showAlert(message: error.localizedDescription)
                }
            } else {
                self?.showAlert(message: "Please check your inbox.") {
                    self?.navigateToLoginScreen()
                }
            }
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToLoginScreen() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            sceneDelegate.setLoginAsRoot()
        }
    }
}
