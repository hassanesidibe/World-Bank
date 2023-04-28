//
//  SignUpVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    let db = Firestore.firestore()
    
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
                    //Create new bank account and save it to database
                    //The savings, checking, and credit card balance should be set to zerp
                    
//                    I STOPPED HERE, I AM ABLE TO SAVE NEW ACCOUNT DATA TO FIRESTORE
                    
                    self.db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.firstNameField : firstName,
                        K.FStore.lastNameField : lastName,
                        K.FStore.emailField : email,
                        K.FStore.checkingBalanceField : "\(Int.random(in: 1000...30000))",
                        K.FStore.savingsBalanceField : "\(Int.random(in: 1000...300000))",
                        K.FStore.creditBalanceField : "\(Int.random(in: 200...2000))"
                        
                    ]) { error in
                        if let err = error {
                            print("There wa an issue saving data to firestore. \(err)")
                        } else {
                            print("Successfully saving data to firestore")
                        }
                    }
                    
                    
                    //navigate to user's account home page
                    self.performSegue(withIdentifier: "signUpToAccount", sender: self)
                    print("Success creating acount with email: \(email), password: \(password)")
                }
            }
        }

        
        
    }

}