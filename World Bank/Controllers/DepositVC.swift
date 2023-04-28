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
                
                if accountType == .checking {
                    userAccountReference.updateData([K.FStore.checkingBalanceField : "\(getAccountBalance(valueToAddToAccount: "100000", .checking))"])
                    
                    I WAS WORKING ON THIS
                    
                    
                } else if accountType == .savings {
                    userAccountReference.updateData([K.FStore.savingsBalanceField : "-99999"])
                }
                
                
            }
            
        } else {
            print("No one is signed in in DepositVC")
        }
        
    }
    
    
    //Adds new value string to checking or savings account
    func getAccountBalance(valueToAddToAccount: String, _ accountType: DepositType) -> Double {
        
        THIS METHOD IS UPDATING THE DEPOSITED AMOUNT ON USER'S ACCOUNT
        
        var balanceToReturn = 0.0
        
        db.collection(K.FStore.collectionName).whereField(K.FStore.emailField, isEqualTo: signedInUserEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        
                        let accountData = accountDocument.data()
                        
//                        let firstName = accountData[K.FStore.firstNameField]
//                        let creditCardBalance = accountData[K.FStore.creditBalanceField]
                        if accountType == .checking {
                            let checkingBalanceString = accountData[K.FStore.checkingBalanceField] as! String
                            if let checkingBalanceDouble = Double(checkingBalanceString) {
                                let valueToDeposit = Double(valueToAddToAccount)!
                                balanceToReturn = (checkingBalanceDouble + valueToDeposit)
                            }
                            
                            
                            
                        } else if accountType == .savings {
                            
                            
                            
                            let savingsBalanceString = accountData[K.FStore.savingsBalanceField] as! String
                        }
                        
                        
                        
                        
                    }
                }
        }
        
        
        
        return balanceToReturn
    }
    
    
    
}





extension DepositVC {
    enum DepositType {
        case checking, savings
    }
}
