//
//  DepositVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/28/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol DepositVCManager {
    func didFinishDepositingMoneyToAccount(_ depositVC: DepositVC)
    func failedToDepositMoneyToAccount(_ depositVC: DepositVC, error: Error)
}


class DepositVC: UIViewController {
    
    let db = Firestore.firestore()
    var banAccount: BankAccountManager?
    var signedInUserEmail: String?
    
//    HomeVC's prepare for segue method will assign a value to this bank account variable below
    var bankAccount: BankAccountManager?
    
    var accountType: BankAccountType?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedAccountType = accountType {
            switch unwrappedAccountType {
            case .checking:
                messageLabel.text = "Checking (XXXX)"
            case .savings:
                messageLabel.text = "Savings (XXXX)"
            case .credit:
                messageLabel.text = "Credit card (XXXX)"
            }
        }
    }
    

    
    @IBAction func depositButtonPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            if let userEmail = Auth.auth().currentUser?.email {
                signedInUserEmail = userEmail
                //I have access to signed in user's account here
                if let amountString = amountTextField.text {
                    if let amount = Double(amountString) {
                        
                        if let unwrappedBankAccount = self.bankAccount {
                            if accountType == .checking {
                                unwrappedBankAccount.deposit(amount, to: .checking)
                                
                            } else if accountType == .savings {
                                unwrappedBankAccount.deposit(amount, to: .savings)
                            }
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            }
            
        } else {
            print("No one is signed in in DepositVC")
        }
        
    }
    
    
}

