//
//  RegisterViewController.swift
//  AI
//
//  Created by Chichek on 23.08.24.
//

import UIKit
import FirebaseAuth
import Lottie

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var myView: UIView!
    
    var controller = ForgotPasswordViewController()
    var onRegisterSuccess: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieView.play()
        lottieView.loopMode = .loop
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myView.layer.shadowRadius = 4
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if let email = email.text, !email.isEmpty,
           let password = password.text, !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    let email = user.email ?? ""
                    print(email)
                    self.onRegisterSuccess?(email, password)
                    self.controller.userEmail = email
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(message: "Please fill the textfields")
                }
            }
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
