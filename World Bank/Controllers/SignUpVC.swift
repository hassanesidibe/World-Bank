//
//  SignUpVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        //Sign up with Firebase, and navigate to account screen
        
        
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let passwordConfirmation = passwordConfirmationTextField.text {

            Auth.auth().createUser(withEmail: email, password: password) {result, error in
                if let err = error {
                    print("Error creating new user's account: \(err)")
                    return

                } else {
                    //navigate to user's account home page
                    self.performSegue(withIdentifier: "signUpToAccount", sender: self)
                    print("Success creating acount with email: \(email), password: \(password)")
                }
            }
        }

        
        
    }

}
