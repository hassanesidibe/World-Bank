//
//  DepositVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/28/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class DepositVC: UIViewController {
    
    let db = Firestore.firestore()
    
    var signedInUserEmail: String?
    
    var newAccountBalance = 0.0  //This variable will hold the new value that should be added to user's account
    
    var accountType: DepositType?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let unwrappedAccountType = accountType {
            switch unwrappedAccountType {
            case .checking:
                messageLabel.text = "Checking (XXXX)"
            case .savings:
                messageLabel.text = "Savings (XXXX)"
            }
        }
    }
    

    
    @IBAction func depositButtonPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            if let userEmail = Auth.auth().currentUser?.email {
                signedInUserEmail = userEmail
                //I have access to signed in user's account here
                let userAccountReference = self.db.collection(K.FStore.collectionName).document(userEmail)
                
                
                if let amountString = amountTextField.text {
                    if let amountDouble = Double(amountString) {
                        
                        if accountType == .checking {
                            depostiToChecking(amount: amountDouble, userEmail: userEmail)
                            
                        } else if accountType == .savings {
                            //Deposit money to savings account
                            depostiToSavings(amount: amountDouble, userEmail: userEmail)
                        }
                        
                    }
                }
                
            }
            
        } else {
            print("No one is signed in in DepositVC")
        }
        
    }
    
    
    func depostiToChecking(amount depositAmount: Double, userEmail: String) {
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.emailField, isEqualTo: signedInUserEmail!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let checkingBalanceString = accountData[K.FStore.checkingBalanceField] as! String
                        
                        if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                            let newBalance = (currentCheckingBalanceDouble + depositAmount)
                            
                            let userAccountReference = self.db.collection(K.FStore.collectionName).document(userEmail)
                            
                            userAccountReference.updateData([K.FStore.checkingBalanceField : "\(newBalance)"])
                        }
                    }
                }
        }
    }
    
    
    func depostiToSavings(amount depositAmount: Double, userEmail: String) {
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.emailField, isEqualTo: signedInUserEmail!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let savingsBalanceString = accountData[K.FStore.savingsBalanceField] as! String
                        
                        if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                            let newBalance = (currentSavingsBalanceDouble + depositAmount)
                            let userAccountReference = self.db.collection(K.FStore.collectionName).document(userEmail)
                            
                            userAccountReference.updateData([K.FStore.savingsBalanceField : "\(newBalance)"])
                        }
                    }
                }
        }
    }
    
    
    
}





extension DepositVC {
    enum DepositType {
        case checking, savings
    }
}
