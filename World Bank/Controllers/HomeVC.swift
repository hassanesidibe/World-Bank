//
//  HomeVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

//I NEED TO CREATE A GITHUB REPOSITORY FOR THIS APP


import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class HomeVC: UIViewController {
    
    let db = Firestore.firestore()
    var currentUserEmail: String?
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    //checking account outlets
    @IBOutlet weak var checkingAccountNumberLabel: UILabel!
    @IBOutlet weak var checkingBalanceLabel: UILabel!
    
    //Savings account outlets
    @IBOutlet weak var savingsAccountNumberLabel: UILabel!
    @IBOutlet weak var savingsBalanceLabel: UILabel!
    
    //credit card account outlets
    @IBOutlet weak var creditAccountNumberLabel: UILabel!
    @IBOutlet weak var creditBalanceLabel: UILabel!
    
    var accountToDepositTo: DepositVC.DepositType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        
        
        if Auth.auth().currentUser != nil {
//            print("I have access to signed in user in HomeVC")
            if let userEmail = Auth.auth().currentUser!.email {
                self.currentUserEmail = userEmail
                //Fetch login user's account info, including checking balance, savings balance, and credit.
                db.collection(K.FStore.collectionName).whereField(K.FStore.emailField, isEqualTo: userEmail)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            if let accountDocument = querySnapshot!.documents.first {
                                print("----------------------------------------------")
                                print("Success Fetching logged in user's account info")
                                print("\(accountDocument.documentID) => \(accountDocument.data())")
                                
                                
                                let accountData = accountDocument.data()
                                
                                let firstName = accountData[K.FStore.firstNameField]
                                let checkingBalance = accountData[K.FStore.checkingBalanceField]
                                let savingsBalance = accountData[K.FStore.savingsBalanceField]
                                let creditCardBalance = accountData[K.FStore.creditBalanceField]
                                
                                //Updating account info UI's
                                self.greetingLabel.text = "Good evening, \(firstName as! String)"
                                
                                self.checkingBalanceLabel.text = (checkingBalance as! String)
                                self.savingsBalanceLabel.text = (savingsBalance as! String)
                                self.creditBalanceLabel.text = (creditCardBalance as! String)
                            }
                            
//                            for document in querySnapshot!.documents {
//                                print("----------------------------------------------")
//                                print("Success Fetching logged in user's account info")
//                                print("\(document.documentID) => \(document.data())")
//                            }
                        }
                }
                
            }
            
            
            
        } else {
            print("I do not have access to login user in HomeVC yet")
        }
    }
    
    //MARK: Depostit to checking and savings
    
//    depositToCheckingPressed() and depositToSavingsPressed are able to segueue to DepositVC
    
    
    @IBAction func depositToCheckingPressed(_ sender: UIButton) {
//        print("depositToCheckingPressed, adding $2500 for testing")
        
        if let checkingLabelValue = checkingBalanceLabel.text {
            let currentCheckingBalance = Float(checkingLabelValue) ?? -10000
            print("Current cheking balance is \(currentCheckingBalance)")
            print("After getting blessed from FAFSA with $2,500 new balance is  $\(currentCheckingBalance + 2500)")
            
            
            accountToDepositTo = .checking
            performSegue(withIdentifier: K.accountToDeposit, sender: self)
            
        }
    }
    
    
    @IBAction func depositToSavingsPressed(_ sender: UIButton) {
        print("depositToSavingsPressed")
        accountToDepositTo = .savings
        performSegue(withIdentifier: K.accountToDeposit, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.accountToDeposit {
            let depositVC = segue.destination as! DepositVC
            depositVC.accountType = accountToDepositTo
            depositVC.signedInUserEmail = self.currentUserEmail
        }
        
        
    }
    
    
    
    
    
    //MARK: Transfer from cheking and savings
    @IBAction func transferFromCheckingPressed(_ sender: UIButton) {
        print("transferFromCheckingPressed")
    }
    
    
    @IBAction func transferFromSavingsPressed(_ sender: UIButton) {
        print("transferFromSavingsPressed")
    }
    
    
    
    
    
    //MARK: Credit card payment
    @IBAction func makeCreditCardPaymentPressed(_ sender: UIButton) {
        print("makeCreditCardPaymentPressed")
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        //sign out current user, and segueue to login screen
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
}
