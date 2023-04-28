//
//  LoginVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let err = error {
                    print("Error loging user in: \(err)")
                    return
                    
                } else {
                    //success loging user in, segueue to user's account
//                    print("Success signing in user 🎉🎉")
                    self.performSegue(withIdentifier: "loginToAccount", sender: self)
                }
            }
        }
        
    }
    
}
